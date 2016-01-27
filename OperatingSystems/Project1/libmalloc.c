#include <unistd.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>
#include <string.h>
#include <errno.h>

// Zwracane adresy muszą być wyrównane do dwukrotności najdłuższego słowa
#define ALIGN_UNIT 16
// Rozmiar obszaru: 128 * 2^12 = 131072
#define AREA_SIZE (1<<17)
// Próg na stworzenie nowego obszaru
#define NEW_AREA_THRESHOLD (1<<17)
// Ile sumarycznie wolnego miejsca powinno być w obszarach, by
// usunąć obszar
#define DESTROY_AREA_CONDITION 4*(1 << 17)
#define DESTROY_AREAS 1
// Minimalna długość obszaru w bloku
#define MIN_BLOCK_SIZE ALIGN_UNIT
// Status bloku w dwukierunkowej liście
#define TAKEN 'T'
#define FREE 'F'


#define DEBUGNUM 0x12345678

#define min(a,b) a <= b ? a : b
#define max(a,b) a >= b ? a : b

//Wg wiki structy mają na końcu dodawane bajty, by sumaryczny rozmiar
//Był wielokrotnością największego pola.

//Lista dwukierunkowa obszarów
//Pamiętamy, jaki był wolny rozmiar w obszarze
typedef struct blockHeader
{
    struct blockHeader *next, *prev;
    void* areaPtr;
    size_t length;
    char type;
    //padding 7 bajtow
    size_t debugNumber;

} blockHeader;

typedef struct area
{
    struct area *next, *prev;
    blockHeader* first;
    size_t size;

    char alignmentPadding[(ALIGN_UNIT -
                        (3*sizeof(void*) + sizeof(size_t)) % ALIGN_UNIT) % ALIGN_UNIT];

} area;

pthread_mutex_t memoryMutex = PTHREAD_MUTEX_INITIALIZER;

area *firstArea = NULL, *lastArea = NULL;
unsigned int areaCount = 0;
unsigned int totalSizeLeft = 0;

/* STATISTICS */
unsigned int areasCreated = 0, areasDestroyed = 0, maxAreaCount = 0;
unsigned int blocksDivided = 0, blocksMerged = 0;
unsigned int blocksShrinked = 0, blocksElongated = 0;
unsigned int mallocCalls = 0, reallocCalls = 0, freeCalls = 0;
unsigned int maxRequest = 0, nullsReturned = 0, mmapFailures = 0;


void printStatistics()
{
    printf("areasCreated = %u, areasDestroyed = %u, maxAreaCount = %u\n", areasCreated, areasDestroyed, maxAreaCount);
    printf("blocksDivided = %u, blocksMerged = %u\n", blocksDivided, blocksMerged);
    printf("blocksShrinked = %u, blocksElongated = %u\n", blocksShrinked, blocksElongated);
    printf("mallocCalls = %u, reallocCalls = %u, freeCalls = %u\n", mallocCalls, reallocCalls, freeCalls);
    printf("maxRequest = %u, nullsReturned = %u, mmapFailures = %u\n", maxRequest, nullsReturned, mmapFailures);
}



void initializeArea(area* a, size_t size)
{
    a->next = NULL;
    a->prev = NULL;
    a->size = size;
    __sync_add_and_fetch(&totalSizeLeft, size - sizeof(area) - sizeof(blockHeader));

    a->first = (blockHeader*)(((char*)a) + sizeof(area));
    a->first->prev = NULL;
    a->first->next = NULL;
    a->first->areaPtr = (void*) a;
    a->first->length = a->size - sizeof(area) - sizeof(blockHeader);
    a->first->type = FREE;
    a->first->debugNumber = DEBUGNUM;
}

area* createNewArea(size_t size)
{
    size += sizeof(area) + sizeof(blockHeader);
    int pageSize = getpagesize();
    size += (pageSize - size % pageSize) % pageSize;

    void* ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if(ptr == (void*)-1)
    {
        mmapFailures++;
        perror("mmap przy tworzeniu nowego obszaru");
    }

    __sync_add_and_fetch(&areasCreated, 1);

    area* newArea = (area*) ptr;
    initializeArea(newArea, size);

    return newArea;
}

void destroyArea(area* toDestroy)
{
    size_t size = toDestroy->size;
    munmap(toDestroy, size);
    __sync_add_and_fetch(&areasDestroyed, 1);
}

void areaListAppend(area* a)
{
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
    areaCount++;
    maxAreaCount = max(maxAreaCount, areaCount);
}

void areaListDelete(area* a)
{
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

    areaCount--;
}

void* allocateBlock(blockHeader* header, size_t size)
{
    size += (ALIGN_UNIT - size % ALIGN_UNIT) % ALIGN_UNIT;

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

    if(header->length - size >= sizeof(blockHeader) + MIN_BLOCK_SIZE)
    {
        __sync_add_and_fetch(&blocksDivided, 1);
        //Dzielę blok na dwa
        blockHeader* newHeader = (blockHeader*)(((char*)header) + sizeof(blockHeader) + size);

        newHeader->type = FREE;
        newHeader->areaPtr = header->areaPtr;
        newHeader->length = header->length - size - sizeof(blockHeader);
        newHeader->debugNumber = DEBUGNUM;

        // Aktualizuje statystyki
        header->type = TAKEN;
        __sync_sub_and_fetch(&totalSizeLeft, size + sizeof(blockHeader));
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
        __sync_sub_and_fetch(&totalSizeLeft, header->length);
    }
    blockHeader* returnAdress = header + 1;
    return returnAdress;
}

void freeBlock(blockHeader* header)
{
    header->type = FREE;
    __sync_add_and_fetch(&totalSizeLeft, header->length);
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

        __sync_add_and_fetch(&totalSizeLeft, sizeof(blockHeader));
        __sync_add_and_fetch(&blocksMerged, 1);
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

        __sync_add_and_fetch(&totalSizeLeft, sizeof(blockHeader));
        __sync_add_and_fetch(&blocksMerged, 1);

    }

}

void shrinkBlock(blockHeader* header, size_t newSize)
{
    newSize += (ALIGN_UNIT - newSize % ALIGN_UNIT) % ALIGN_UNIT;

    //Jeśli
    if(header->next != NULL && header->next->type == FREE)
    {

        blockHeader* newNext =
                (blockHeader*)(((char*)header) + sizeof(blockHeader) + newSize);
        memmove(newNext, header->next, sizeof(blockHeader));

        __sync_add_and_fetch(&totalSizeLeft, header->length - newSize);
        newNext->length += header->length - newSize;

        header->length = newSize;
        header->next = newNext;

        __sync_add_and_fetch(&blocksShrinked, 1);

    }
    else
    {
        // Jeśli miejsce zwolnione będzie zbyt małe, no to bez przesady
        // nie będziemy dla niego robić block headera
        if(header->length - newSize >= sizeof(blockHeader) + MIN_BLOCK_SIZE)
        {
            // Dodajemy nowy wolny blok w liście
            __sync_add_and_fetch(&blocksShrinked, 1);
            __sync_add_and_fetch(&totalSizeLeft,
                    header->length - newSize - sizeof(blockHeader));

            blockHeader* newHeader =
                    (blockHeader*)(((char*)header) + sizeof(blockHeader) + newSize);

            newHeader->type = FREE;
            newHeader->length = header->length - newSize - sizeof(blockHeader);
            newHeader->areaPtr = header->areaPtr;
            newHeader->next = header->next;
            newHeader->prev = header;
            newHeader->debugNumber = DEBUGNUM;
            if(newHeader->next != NULL)
            {
                newHeader->next->prev = newHeader;
            }

            header->next = newHeader;
            header->length = newSize;
        }
    }
}

int elongateBlock(blockHeader* header, size_t newSize)
{
    newSize += (ALIGN_UNIT - newSize % ALIGN_UNIT) % ALIGN_UNIT;

    blockHeader* next = header->next;
    if(next != NULL && next->type == FREE)
    {
        __sync_add_and_fetch(&blocksElongated, 1);
        size_t toElongate = newSize - header->length;
        size_t freeSpace = next->length + sizeof(blockHeader);

        if(freeSpace >= toElongate)
        {
            // Jestem w stanie wydłużyć blok!
            // Zastanówmy się, czy wziąć cały, czy coś zostawić
            if(freeSpace - toElongate >= sizeof(blockHeader) + MIN_BLOCK_SIZE)
            {
                // Dzielimy blok
                next = (blockHeader*) memmove(((char*)next) + toElongate, next, sizeof(blockHeader));
                next->length = freeSpace - toElongate - sizeof(blockHeader);

                header->next = next;
                header->length += toElongate;
                __sync_sub_and_fetch(&totalSizeLeft, toElongate + sizeof(blockHeader));
            }
            else
            {
                // Bierzemy cały
                header->length += freeSpace;
                if(next->next != NULL)
                {
                    next->next->prev = header;
                }
                header->next = next->next;

                __sync_sub_and_fetch(&totalSizeLeft, next->length);
            }

            return 1;
        }
    }
    return 0;
}


void* malloc(size_t size)
{
    pthread_mutex_lock(&memoryMutex);

    maxRequest = max(maxRequest, size);
    __sync_add_and_fetch(&mallocCalls, 1);

    void* ptr;
    area* nextArea;
    // Jeśli mniejszy rozmiar niż próg, to stwórz nowy obszar
    if(size + sizeof(area) + sizeof(blockHeader) < NEW_AREA_THRESHOLD)
    {
        area* currentArea = firstArea;

        while(currentArea != NULL)
        {
            ptr = allocateBlock(currentArea->first, size);
            nextArea = currentArea->next;

            if(ptr != NULL)
            {
                pthread_mutex_unlock(&memoryMutex);
                return ptr;
            }

            currentArea = nextArea;
        }
    }

    // Skoro tutaj jestem, to albo żądany rozmiar jest duży
    // Tworzę obszar z jednym zajętym blokiem i podpinam go do listy


    area* newArea = createNewArea(max(AREA_SIZE, size));

    ptr = allocateBlock(newArea->first, size);
    areaListAppend(newArea);

    if(ptr == NULL) nullsReturned++;
    pthread_mutex_unlock(&memoryMutex);


    return ptr;
}

void free(void* ptr)
{
    pthread_mutex_lock(&memoryMutex);
    __sync_add_and_fetch(&freeCalls, 1);

    if(ptr == NULL)
    {
        pthread_mutex_unlock(&memoryMutex);
        return;
    }

    blockHeader* header = (blockHeader*)ptr - 1;
    area* oldArea = header->areaPtr;


    freeBlock(header);


    // Czy obszar składa się z jednego wolnego bloku?
    if(oldArea->first->length + sizeof(blockHeader) + sizeof(area) < oldArea->size
        || oldArea->first->type == TAKEN)
    {
        pthread_mutex_unlock(&memoryMutex);
        return;
    }

    // Czy wolna pamięć w pozostałych obszarach przekracza ustalony próg?


    if(DESTROY_AREAS && totalSizeLeft >= DESTROY_AREA_CONDITION)
    {
        areaListDelete(oldArea);
        destroyArea(oldArea);
    }

    pthread_mutex_unlock(&memoryMutex);
}

void* calloc(size_t count, size_t size)
{
    void* ptr = malloc(count * size);
    if(ptr == NULL)
    {
        return NULL;
    }
    memset(ptr, 0, count * size);

    return ptr;
}

void* realloc(void* ptr, size_t size)
{
    __sync_add_and_fetch(&reallocCalls, 1);

    if(ptr == NULL && size > 0)
    {
        return malloc(size);
    }
    else if(ptr == NULL && size == 0)
    {
        free(ptr);
        return NULL;
    }

    size += (ALIGN_UNIT - size % ALIGN_UNIT) % ALIGN_UNIT;
    blockHeader* header = (blockHeader*)ptr - 1;

// KURCZENIE BLOKU COS PSUJE

    pthread_mutex_lock(&memoryMutex);

    // wyglada na to, ze skracanie psuje cos, mozna zrobic petle

    if(header->length >= size)
    {
        shrinkBlock(header, size);
        pthread_mutex_unlock(&memoryMutex);
        return ptr;
    }

    else if(elongateBlock(header, size))
    {
        //Udało się wydłużyć blok
        pthread_mutex_unlock(&memoryMutex);
        return ptr;
    }


    pthread_mutex_unlock(&memoryMutex);

    //Wszystko zawiodło, muszę znaleźć nowy blok

    void* newPtr = malloc(size);
    //tutaj był błąd
    memmove(newPtr, ptr, min(header->length, size));
    free(ptr);

    return newPtr;
}

void printAreaState(area *currentArea)
{
    pthread_mutex_lock(&memoryMutex);

    printf("-----------------\n");
    printf("Obszar %p, ", currentArea);
    printf("rozmiar %lu\n", currentArea->size);
    printf("-----------------\n");

    blockHeader* header = currentArea->first;
    while(header != NULL)
    {
        printf("%p, ", header);
        fflush(stdout);
        printf("%c ", header->type);
        printf("rozmiar %lu ", header->length);
        printf("prev %p next %p\n", header->prev, header->next);

        header = header->next;
    }

    printf("Przeszedłem już wszystkie bloki obszaru\n" );
    pthread_mutex_unlock(&memoryMutex);
}

void printMemoryState()
{
    pthread_mutex_lock(&memoryMutex);

    //printStatistics();
    printf("-----------------\n");
    printf("STAN PAMIĘCI\n");
    printf("-----------------\n");


    area* currentArea = firstArea;
    while(currentArea != NULL)
    {
        printf("-----------------\n");
        printf("Obszar %p, ", currentArea);
        printf("rozmiar %lu\n", currentArea->size);
        printf("-----------------\n");

        blockHeader* header = currentArea->first;
        while(header != NULL)
        {
            printf("%p, ", header);
            fflush(stdout);
            printf("%c ", header->type);
            printf("rozmiar %lu ", header->length);
            printf("prev %p next %p\n", header->prev, header->next);

            header = header->next;
        }

        printf("Przeszedłem już wszystkie bloki obszaru\n" );

        currentArea = currentArea->next;
    }

    pthread_mutex_unlock(&memoryMutex);
}
