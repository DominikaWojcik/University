#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<time.h>

#define MIN_SLEEP  1
#define MAX_SLEEP 1
#define MICROSECOND 1000

#define PRODUCERS 200
#define CONSUMENTS 200
#define GOODS 1000000

pthread_mutex_t mutex;
pthread_cond_t notEmpty, notFull;
int* buffer;
int nextIn=0, nextOut=0, elements=0;
int N = 320000;

pthread_t *threadInfo;
int *threadGoods;

void append(int what)
{
	pthread_mutex_lock(&mutex);

	while(elements == N)
	{
		pthread_cond_wait(&notFull, &mutex);
	}

	buffer[nextIn] = what;
	nextIn = (nextIn + 1) % N;
	elements++;


	pthread_cond_signal(&notEmpty);

	pthread_mutex_unlock(&mutex);

}

int take()
{
	pthread_mutex_lock(&mutex);

	while(elements == 0)
	{
		pthread_cond_wait(&notEmpty, &mutex);
	}
	
	int retVal = buffer[nextOut];
	nextOut = (nextOut + 1) % N;
	elements--;

	pthread_cond_signal(&notFull);

	pthread_mutex_unlock(&mutex);
	return retVal;
}

void* producer(void* arg)
{
	int toProduce = *(int*)arg;

	for(int i=0;i<toProduce;i++)
	{
		append(i);

		long randTime = (rand() % (MAX_SLEEP - MIN_SLEEP + 1) + MIN_SLEEP) * MICROSECOND;
		struct timespec tmspc;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;
		nanosleep(&tmspc, NULL);
	}

	return NULL;
}

void* consument(void* arg)
{
	int toConsume = *(int*)arg;

	for(int i=0; i<toConsume;i++)
	{
		take();

		long randTime = (rand() % (MAX_SLEEP - MIN_SLEEP + 1) + MIN_SLEEP) * MICROSECOND;
		struct timespec tmspc;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;
		nanosleep(&tmspc, NULL);
	}

	return NULL;
}

int makeRandom(int a, int b)
{
	return rand()%(b-a+1) + a;
}

int main()
{
	srand(time(NULL));

	threadInfo = calloc(PRODUCERS + CONSUMENTS, sizeof(pthread_t));
	threadGoods = calloc(PRODUCERS + CONSUMENTS, sizeof(int));
	buffer = calloc(N, sizeof(int));

	pthread_mutex_init(&mutex, NULL);
	pthread_cond_init(&notFull, NULL);
	pthread_cond_init(&notEmpty, NULL);

	int consumentsGoods = GOODS, producersGoods = GOODS;

	for(int i=0; i<CONSUMENTS; i++)
	{
		threadGoods[i] = makeRandom(1, consumentsGoods - (CONSUMENTS -(i + 1)));
		consumentsGoods -= threadGoods[i];
		if(i+1 == CONSUMENTS) threadGoods[i] += consumentsGoods;
		pthread_create(&threadInfo[i], NULL, consument, &threadGoods[i]); 
	}

	for(int i=CONSUMENTS; i<CONSUMENTS + PRODUCERS; i++)
	{
		threadGoods[i] = makeRandom(1, producersGoods - (PRODUCERS -((i - CONSUMENTS) + 1)));
		producersGoods -= threadGoods[i];
		if(i+1 == CONSUMENTS + PRODUCERS) threadGoods[i] += producersGoods;
		pthread_create(&threadInfo[i], NULL, producer, &threadGoods[i]);
	}

	for(int i=0; i<CONSUMENTS + PRODUCERS; i++)
	{
		void* retVal;
		pthread_join(threadInfo[i], &retVal);
	}

	free(threadInfo);
	free(threadGoods);
	free(buffer);

	return 0;
}

