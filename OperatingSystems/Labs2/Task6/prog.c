#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>
#include<semaphore.h>

//Flagi mówiące, który zasób leży na stole
//Uzywane przez watki pomocnicze flagi
int isTobacco=0, isPaper=0, isMatches=0;
// pierwsze 3 semafory na zasoby, mutex na flagi, reszta oczywista
sem_t tobacco, paper, matches, mutex, finishedSmoking, wakeupMatches, wakeupPaper, wakeupTobacco;

void* agent()
{
	while(1)
	{
		int num = rand()%3;
		if(num == 0)
		{
			// tyton i bibulki
			sem_post(&tobacco);
			sem_post(&paper);
		}
		else if(num == 1)
		{
			//tyton i zapalki
			sem_post(&tobacco);
			sem_post(&matches);
		}
		else
		{
			//zapalki i bibulki
			sem_post(&matches);
			sem_post(&paper);
		}
		sem_wait(&finishedSmoking);
	}
	return NULL;
}

void* helperTobacco()
{
	while(1)
	{
		sem_wait(&tobacco);

		sem_wait(&mutex);

		if(isPaper) sem_post(&wakeupMatches);
		else if(isMatches) sem_post(&wakeupPaper);
		else isTobacco = 1;

		sem_post(&mutex);
	}
	return NULL;
}

void* helperPaper()
{
	while(1)
	{
		sem_wait(&paper);

		sem_wait(&mutex);

		if(isTobacco) sem_post(&wakeupMatches);
		else if(isMatches) sem_post(&wakeupTobacco);
		else isPaper = 1;

		sem_post(&mutex);
	}
	return NULL;
}

void* helperMatches()
{
	while(1)
	{
		sem_wait(&matches);

		sem_wait(&mutex);

		if(isTobacco) sem_post(&wakeupPaper);
		else if(isPaper) sem_post(&wakeupTobacco);
		else isMatches = 1;

		sem_post(&mutex);
	}
	return NULL;
}

void* tobaccoSmoker()
{
	while(1)
	{
		sem_wait(&wakeupTobacco);
		isMatches = 0;
		isPaper = 0;
		printf("Palacz z tytoniem\n");
		sem_post(&finishedSmoking);
	}
	return NULL;
}

void* paperSmoker()
{
	while(1)
	{
		sem_wait(&wakeupPaper);
		isTobacco = 0;
		isMatches = 0;
		printf("Palacz z bibulkami\n");
		sem_post(&finishedSmoking);
	}
	return NULL;
}

void* matchesSmoker()
{
	while(1)
	{
		sem_wait(&wakeupMatches);
		isTobacco = 0;
		isPaper = 0;
		printf("Palacz z zapalkami\n");
		sem_post(&finishedSmoking);
	}
	return NULL;
}

pthread_t* threadInfo;

int main()
{
	sem_init(&tobacco, 0 ,0);
	sem_init(&matches, 0 ,0);
	sem_init(&paper, 0 ,0);

	sem_init(&wakeupTobacco, 0, 0);
	sem_init(&wakeupPaper, 0, 0);
	sem_init(&wakeupMatches, 0, 0);

	sem_init(&mutex, 0, 1);

	threadInfo = calloc(7, sizeof(pthread_t));

	pthread_create(&threadInfo[0], NULL, agent, NULL);
	pthread_create(&threadInfo[1], NULL, helperTobacco, NULL);
	pthread_create(&threadInfo[2], NULL, helperPaper, NULL);
	pthread_create(&threadInfo[3], NULL, helperMatches, NULL);
	pthread_create(&threadInfo[4], NULL, tobaccoSmoker, NULL);
	pthread_create(&threadInfo[5], NULL, paperSmoker, NULL);
	pthread_create(&threadInfo[6], NULL, matchesSmoker, NULL);

	for(int i=0;i<7;i++)
	{
		void* retVal;
		pthread_join(threadInfo[i], &retVal);
	}

	return 0;
}
