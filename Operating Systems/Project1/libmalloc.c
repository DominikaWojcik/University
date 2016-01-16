#include <unistd.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>
#include <string.h>

// Zwracane adresy muszą być wyrównane do dwukrotności najdłuższego słowa
#define ALLIGN_UNIT 16
// Rozmiar obszaru: 128 * 2^12 = 131072
#define AREA_SIZE (1<<17)
// Próg na stworzenie nowego obszaru
#define NEW_AREA_THRESHOLD (1<<17)
// Ile sumarycznie wolnego miejsca powinno być w obszarach, by
// usunąć obszar
#define DESTROY_AREA_CONDITION 4*(1 << 17)
// Status bloku w dwukierunkowej liście
#define TAKEN 1
#define FREE 0


#define max(a,b) a >= b ? a : b

//Wg wiki structy mają na końcu dodawane bajty, by sumaryczny rozmiar
//Był wielokrotnością największego pola.

//Lista dwukierunkowa obszarów
//Pamiętamy, jaki był wolny rozmiar w obszarze
typedef struct blockHeader
{
    struct blockHeader *next, *prev;
    void* areaPtr;
    unsigned int length;
    char type;

} blockHeader;

typedef struct area
{
    pthread_mutex_t mutex;
    struct area *next, *prev;
    blockHeader* first;
    size_t size;
    size_t totalSizeLeft;
    unsigned int threadCount;

    char allignmentPadding[ALLIGN_UNIT - (sizeof(pthread_mutex_t) +
                        3*sizeof(void*) + 2*sizeof(size_t) +
                        sizeof(unsigned int)) % ALLIGN_UNIT];

} area;

pthread_mutex_t areaListMutex = PTHREAD_MUTEX_INITIALIZER;

area *firstArea = NULL, *lastArea = NULL;
unsigned int areaCount = 0;
unsigned int totalSizeLeft = 0;


void initializeArea(area* a, size_t size)
{
    pthread_mutex_init(a->mutex, NULL);
    a->next = NULL;
    a->prev = NULL;
    a->size = size;
    a->totalSizeLeft = size - sizeof(area) - sizeof(blockHeader);
    a->threadCount = 0;

    a->first = a + sizeof(area);
    a->first->prev = NULL;
    a->first->next = NULL;
    a->first->areaPtr = (void*) a;
    a->first->length = a->totalSizeLeft;
    a->first->type = FREE;
}

area* createNewArea(size_t size)
{
    int pageSize = getpagesize();
    size += pageSize - size % pageSize;

    void* ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS, -1, 0);

    area* newArea = (area*) ptr;
    initializeArea(newArea, size);
}

void destroyArea(area* toDestroy)
{
    pthread_mutex_destroy(toDestroy->mutex);
    size_t size = toDestroy->size;

    munmap(toDestroy, size);
}

void areaListAppend(area* a)
{
    pthread_mutex_lock(&areaListMutex);

    if(areaCount == 0)
    {
        firstArea = a;
        lastArea = a;
    }
    else
    {
        lastArea->next = a;
        a->prev = lastArea;
        lastArea = a;
    }
    __sync_add_and_fetch(areaCount, 1);

    pthread_mutex_unlock(&areaListMutex);
}

void areaListDelete(area* a)
{
    pthread_mutex_lock(&areaListMutex);

    area *prev = a->prev, *next = a->next;

    if(prev != NULL)
    {
        prev->next = next;
    }
    else
    {
        firstArea = next;
    }

    if(next != NULL)
    {
        next->prev = prev;
    }
    else
    {
        lastArea = prev;
    }

    pthread_mutex_unlock(&areaListMutex);
    __sync_sub_and_fetch(areaCount, 1);
}

void* allocateBlock(blockHeader* header, size_t size)
{
    size += ALLIGN_UNIT - size % ALLIGN_UNIT;

    while(header != NULL)
    {
        if(header->type == FREE && header->length >= size)
        {
            //Znaleźliśmy blok
            break;
        }
        header = header->next;
    }
    if(header == NULL) return NULL;

    if(header->length - size >= 2 * sizeof(blockHeader))
    {
        //Dzielę blok na dwa
        blockHeader* newHeader = header + sizeof(blockHeader) + size;
        newHeader->type = FREE;
        newHeader->areaPtr = header->areaPtr;
        newHeader->length = header->length - size - sizeof(blockHeader);
        // Aktualizuje statystyki
        header->type = TAKEN;
        header->areaPtr->totalSizeLeft -= size + sizeof(blockHeader);
        header->length = size;
        // Podłączam bloki do siebie
        if(header->next != NULL)
        {
            header->next->prev = newHeader;
        }
        newHeader->next = header->next;
        header->next = newHeader;
        newHeader->prev = header;
    }
    else
    {
        // Biorę wszystko w tym bloku
        header->type = TAKEN;
        header->areaPtr->totalSizeLeft -= header->length;
    }

    return header;
}

void freeBlock(blockHeader* header)
{
    area* ownerArea = header->areaPtr;

    header->type = FREE;
    ownerArea->totalSizeLeft += header->length;
    blockHeader *prev = header->prev, *next = header->next;

    if(next != NULL && next->type == FREE)
    {
        // Łączymy dalszy blok
        if(next->next != NULL)
        {
            next->next->prev = header;
        }
        header->next = next->next;
        header->length += sizeof(blockHeader) + next->length;

        ownerArea->totalSizeLeft += sizeof(blockHeader);
    }

    if(prev != NULL && prev->type == FREE)
    {
        // Łączymy się z poprzednim blokiem
        if(header->next != NULL)
        {
            header->next->prev = prev;
        }
        prev->next = header->next;
        prev->length += sizeof(blockHeader) + header->length;

        ownerArea->totalSizeLeft += sizeof(blockHeader);
    }

}


void* malloc(size_t size)
{
    // Jeśli mniejszy rozmiar niż próg, to stwórz nowy obszar
    if(size + sizeof(area) + sizeof(blockHeader) < NEW_AREA_THRESHOLD)
    {
        area* currentArea = firstArea;

        while(currentArea != NULL)
        {
            __sync_add_and_fetch(currentArea->threadCount, 1);
            if(pthread_mutex_trylock(currentArea->mutex) == 0)
            {
                //Założyliśmy blokadę
                void* ptr = allocateBlock(area->first, size);
                void* nextArea = currentArea->next;
                pthread_mutex_unlock(currentArea->mutex);
            }
            __sync_sub_and_fetch(currentArea->threadCount, 1);

            if(ptr != NULL)
            {
                return ptr;
            }

            currentArea = nextArea;
        }
    }
    // Skoro tutaj jestem, to albo żądany rozmiar jest duży, albo
    // nie znalazłem wolnego obszaru/bloku.
    // Tworzę obszar z jednym zajętym blokiem i podpinam go do listy

    area* newArea = createNewArea(max(AREA_SIZE, size));
    pthread_mutex_lock(newArea->mutex);
    __sync_add_and_fetch(newArea->threadCount, 1);

    void* ptr = allocateBlock(newArea->first, size);

    areaListAppend(newArea);
    __sync_sub_and_fetch(newArea->threadCount, 1);
    pthread_mutex_unlock(newArea->mutex);

    return ptr;
}

void free(void* ptr)
{
    blockHeader* header = ptr - sizeof(blockHeader);
    area* oldArea = header->areaPtr;

    __sync_add_and_fetch(oldArea->threadCount, 1);
    pthread_mutex_lock(oldArea->mutex);
    freeBlock(header);

    // Czy obszar składa się z jednego wolnego bloku?
    if(oldArea->first->length < oldArea->totalSizeLeft
        || oldArea->first->type == TAKEN)
    {
        __sync_sub_and_fetch(oldArea->threadCount, 1);
        pthread_mutex_unlock(oldArea->mutex);
        return;
    }

    // Czy wolna pamięć w pozostałych obszarach przekracza ustalony próg?
    unsigned int freeMemory = 0;
    area* currentArea = firstArea;

    while(currentArea != NULL)
    {
        if(currentArea != oldArea)
        {
            freeMemory += currentArea->totalSizeLeft;
        }
        currentArea = currentArea->next;
    }

    if(freeMemory >= DESTROY_AREA_CONDITION)
    {
        areaListDelete(oldArea);

        while(oldArea->threadCount > 1)
        {
            // Czekaj
        }
        destroyArea(oldArea);
    }
    else
    {
        __sync_sub_and_fetch(oldArea->threadCount, 1);
        pthread_mutex_unlock(oldArea->mutex);
    }
}

void* calloc(size_t count, size_t size)
{
    void* ptr = malloc(count * size);
    memset(ptr, 0, count * size);
    return ptr;
}

void* realloc(void* ptr, size_t size)
{
    blockHeader* header = ptr - sizeof(blockHeader);
    if(header->length > size) return NULL;
    else if(header->length == size) return ptr;

    void* newPtr = malloc(size);
    memcpy(newPtr, ptr, header->length);
    free(ptr);

    return newPtr;
}

void printMemoryState()
{
    printf("-----------------\n");
    printf("STAN PAMIĘCI\n");
    printf("-----------------\n");
    area* currentArea = firstArea;
    while(currentArea != NULL)
    {
        pthread_mutex_lock(currentArea->mutex);
        printf("-----------------\n");
        printf("Obszar %p, rozmiar %lu\n", currentArea, currentArea->)
        printf("-----------------\n");

        blockHeader* header = currentArea->first;
        while(header != NULL)
        {
            if(header->type == FREE)
            {
                printf("F ");
            }
            else
            {
                printf("T ");
            }
            printf("%p, rozmiar %lu\n", header + sizeof(header), header->length);

            header = header->next;
        }

        pthread_mutex_unlock(currentArea->mutex);
        currentArea = currentArea->next;
    }
}

int main()
{
    printf("Rozmiar strony %u\n", getpagesize());
    printf("Rozmiar wskaźnika %lu\n", sizeof(void*));
    printf("Rozmiar mutexu %lu\n", sizeof(pthread_mutex_t));
    printf("Rozmiar obszaru %lu\n", sizeof(area));
    printf("Rozmiar bloku %lu\n", sizeof(blockHeader));
    return 0;
}
