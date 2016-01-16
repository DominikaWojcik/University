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
#define MEM_TO_DESTROY_AREA 4*(1 << 17)
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
    unsigned int size;
    unsigned int totalSizeLeft;
    unsigned int threadCount;

    char allignmentPadding[ALLIGN_UNIT - (sizeof(pthread_mutex_t) +
                        4*sizeof(void*) +sizeof(unsigned int)) % ALLIGN_UNIT];

} area;

pthread_mutex_t areaListMutex;
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

void* allocateFreeBlock(blockHeader* header, size_t size)
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
    header->type = FREE;
    
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
                void* ptr = allocateFreeBlock(area->first, size);
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
    // nie znalazłem wolnej areny/wolnego bloku.
    // Tworzę obszar z jednym zajętym blokiem i podpinam go do listy

    area* newArea = createNewArea(max(AREA_SIZE, size));
    pthread_mutex_lock(newArea->mutex);
    newArea->threadCount = 1;

    void* ptr = allocateFreeBlock(newArea->first, size);

    areaListAppend(newArea);
    __sync_sub_and_fetch(newArea->threadCount, 1);
    pthread_mutex_unlock(newArea->mutex);

    return ptr;
}

void* calloc(size_t count, size_t size)
{

}

void* realloc(void* ptr, size_t size)
{

}

void free(void* ptr)
{

}

void printMemoryState()
{

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
