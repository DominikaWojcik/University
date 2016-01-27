#include<semaphore.h>
#include<sys/wait.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/mman.h>
#include<sys/fcntl.h>
#include<unistd.h>

#define POT_CAPACITY 10
#define SAVAGES 490 

typedef struct
{
	int pot;
	sem_t potEmpty, potFull, potAccess;
} Data;

void initializeData(Data* d)
{
	d->pot = 0;
	sem_init(&d->potAccess, 1, 1);
	sem_init(&d->potFull, 1, 0);
	sem_init(&d->potEmpty, 1, 0);
}

Data* data;

void cook()
{
	for(int i=0; i<SAVAGES/POT_CAPACITY; i++)
	{
		sem_wait(&data->potEmpty);

		data->pot = POT_CAPACITY;
		printf("Kucharz napełnił gar\n");

		sem_post(&data->potFull);
	}
}

void savage()
{
	sem_wait(&data->potAccess);

	if(data->pot == 0)
	{
		sem_post(&data->potEmpty);
		sem_wait(&data->potFull);
	}

	data->pot--;

	sem_post(&data->potAccess);
 	//je
	printf("Dzikus je\n");
}


int main()
{
	int fileDesc = shm_open("/sharedData", O_CREAT | O_RDWR | O_TRUNC, S_IRUSR | S_IWUSR);
	ftruncate(fileDesc, sizeof(Data));
	data = mmap(NULL, sizeof(Data), PROT_READ | PROT_WRITE, MAP_SHARED, fileDesc, 0);

	initializeData(data);

	pid_t childPid;

	if((childPid = fork()) == 0)
	{
		cook();
		return 0;
	}

	for(int i=0; i<SAVAGES; i++)
	{
		if((childPid = fork()) == 0)
		{
			savage();
			return 0;
		}
	}

	for(int i=0; i<SAVAGES+1; i++)
	{
		int status;
		childPid = wait(&status);
	}

	return 0;
}
