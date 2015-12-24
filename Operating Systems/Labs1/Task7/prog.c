#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#define THREAD_NUMBER 10

int makeRandom(int a, int b)
{
	return rand()%(b-a+1) + a;
}

static __thread int identifier;
pthread_barrier_t barrier1, barrier2;

void* runThread(void* arg)
{
	int uniqueId = *(int*)arg;

	pthread_barrier_wait(&barrier1);
	identifier = uniqueId;

	pthread_barrier_wait(&barrier2);
	printf("Unique id: %d\nSystem id: %lu\n", identifier, pthread_self());

	sleep(makeRandom(1,10));
	return 0;
}

int main(int argc, char* argv[])
{
	srand(time(NULL));

	pthread_t* threads = calloc(THREAD_NUMBER, sizeof(pthread_t));
	int* ids = calloc(THREAD_NUMBER, sizeof(int));

	pthread_barrier_init(&barrier1, NULL, THREAD_NUMBER);
	pthread_barrier_init(&barrier2, NULL, THREAD_NUMBER);

	for(int i=0;i<THREAD_NUMBER;i++)
	{
		ids[i]=i; 
		// pthread_attr daje null by miec domyslne atrybuty
		if(pthread_create(&threads[i], NULL, runThread, &ids[i]) != 0)
		{
			printf("Nie udalo sie zrobic watku %d\n", ids[i]);
			return 1;
		}
	}

	void* result;
	for(int i=0;i<THREAD_NUMBER;i++)
	{
		if(pthread_join(threads[i], &result) != 0)
		{
			printf("Nie udalo sie zjoinowac z watkiem %d\n", i);
			return 1;
		}
		printf("Poloczono sie z watkiem %d. Zwrocono %s\n", i, (char *) result);
		free(result);
	}

	free(threads);
	free(ids);
	return 0;
}