#include<stdlib.h>
#include<time.h>
#include<sys/time.h>
#include<pthread.h>
#include<stdio.h>
#include<semaphore.h>

#define READER 0
#define WRITER 1

#define MIN_SLEEP  10
#define MAX_SLEEP 100
#define MICROSECOND 1000

#define INF 1e9+7

//Shared
pthread_mutex_t queue, libraryAccess, readcountMutex;
int readersInLibrary = 0;
//

//


sem_t maxThreads;
int N, M, T;
int readersMaxWait = 0, writersMaxWait = 0;

void* writer()
{
	sem_wait(&maxThreads);

	struct timeval tv;
	gettimeofday(&tv, NULL);
	int waitTime = tv.tv_usec;

	pthread_mutex_lock(&queue);
	pthread_mutex_lock(&libraryAccess);

	gettimeofday(&tv, NULL);
	waitTime = tv.tv_usec - waitTime;

	pthread_mutex_unlock(&queue);

	long randTime = (rand() % (MAX_SLEEP - MIN_SLEEP + 1) + MIN_SLEEP) * MICROSECOND;
	struct timespec tmspc;
	tmspc.tv_sec = 0;
	tmspc.tv_nsec = randTime;

	nanosleep(&tmspc, NULL);

	pthread_mutex_unlock(&libraryAccess);

	sem_post(&maxThreads);
	
	int *retAddr = (int*) calloc(1, sizeof(int));
	*retAddr = waitTime;
	return retAddr;
}

void* reader()
{
	sem_wait(&maxThreads);

	struct timeval tv;
	gettimeofday(&tv, NULL);
	int waitTime = tv.tv_usec;

	pthread_mutex_lock(&queue);

	pthread_mutex_lock(&readcountMutex);

	if(readersInLibrary == 0)
		pthread_mutex_lock(&libraryAccess);
	
	gettimeofday(&tv, NULL);
	waitTime = tv.tv_usec - waitTime;

	readersInLibrary++;
	
	pthread_mutex_unlock(&queue);
	pthread_mutex_unlock(&readcountMutex);

	long randTime = (rand() % (MAX_SLEEP - MIN_SLEEP + 1) + MIN_SLEEP) * MICROSECOND;
	struct timespec tmspc;
	tmspc.tv_sec = 0;
	tmspc.tv_nsec = randTime;

	nanosleep(&tmspc, NULL);
	
	pthread_mutex_lock(&readcountMutex);
	readersInLibrary--;
	if(readersInLibrary == 0)
		pthread_mutex_unlock(&libraryAccess);
	
	pthread_mutex_unlock(&readcountMutex);	

	sem_post(&maxThreads);	
	int *retAddr = (int*) calloc(1, sizeof(int));
	*retAddr = waitTime;
	return retAddr;
}


int main()
{
	pthread_mutex_init(&queue, NULL);	
	pthread_mutex_init(&libraryAccess, NULL);	
	pthread_mutex_init(&readcountMutex, NULL);

	srand(time(NULL));

	printf("Ile wątków ma być tworzone co jakiś czas?\n");
	scanf("%d",&N);
	printf("Ile najwięcej wątków może działać jednocześnie?\n");
	scanf("%d",&M);
	printf("Ile sumarycznie wątków stworzyć?\n");
	scanf("%d",&T);

	pthread_t *threadInfo = calloc(T, sizeof(pthread_t));
	int *threadType = calloc(T, sizeof(int));
	sem_init(&maxThreads, 0, M); 
	
	long randTime;
	struct timespec tmspc;

	int threadId = 0;
	while(threadId < T)
	{
		randTime = (rand() % (MAX_SLEEP - MIN_SLEEP + 1) + MIN_SLEEP) * MICROSECOND;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;
		nanosleep(&tmspc, NULL);

		for(int i=0; i<N; i++)
		{
			threadType[threadId] = rand()%2;
			if(threadType[threadId] == READER)
			{
				pthread_create(&threadInfo[threadId], NULL, reader, NULL);
			}
			else
			{
				pthread_create(&threadInfo[threadId], NULL, writer, NULL);
			}
			threadId++;
		}
	}

	for(int i=0; i<T; i++)
	{
		int *retVal;
		pthread_join(threadInfo[i], (void **) &retVal);
		if(threadType[i] == READER)
		{
			if(readersMaxWait < *retVal)
				 readersMaxWait = *retVal;
		}
		else
		{
			if(writersMaxWait < *retVal)
				writersMaxWait =  *retVal;
		}
		free(retVal);
	}

	printf("Maksymalny czas oczekiwania czytelnika: %d\nMaksymalny czas oczekiwania pisarza: %d\n", readersMaxWait, writersMaxWait);
	
	free(threadInfo);
	free(threadType);
	return 0;	
}
