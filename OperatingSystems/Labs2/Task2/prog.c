#include<semaphore.h>
#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<sys/wait.h>
#include<unistd.h>
#include<sys/mman.h>
#include<sys/stat.h>
//#include"barrier.h"

typedef struct
{
	int N, count;
	sem_t doorIn, doorOut, mutex;

} barrier;

void barrier_init(barrier* bar, int n)
{
	bar->N = n;
	bar->count = 0;
	sem_init(&bar->mutex, 1, 1);
	sem_init(&bar->doorIn, 1, n);
	sem_init(&bar->doorOut, 1, 0);
}

void barrier_wait(barrier* bar)
{
	sem_wait(&bar->doorIn);
	//przechodze przez pierwsza bariere
	sem_wait(&bar->mutex);
	bar->count++;
	if(bar->count==bar->N)
	{
		sem_post(&bar->doorOut); //otwieram drugie drzwi
	}
	sem_post(&bar->mutex);

	sem_wait(&bar->doorOut);

	sem_wait(&bar->mutex);
	bar->count--;
	if(bar->count>0)
		sem_post(&bar->doorOut);
	else
	{
		//ustaw liczik pierwszych drzwi z powrotem na N
		for(int i=0;i<bar->N;i++)
			sem_post(&bar->doorIn);
	}
	sem_post(&bar->mutex);
}


void barrier_destroy(barrier* bar)
{
	sem_destroy(&bar->mutex);
	sem_destroy(&bar->doorIn);
	sem_destroy(&bar->doorOut);
	bar->count=0;
	bar->N=0;
}


barrier* myBarrier;

int main(int argc, char* argv[])
{

	int fileDesc = shm_open("/barrier", O_CREAT | O_RDWR | O_TRUNC, S_IRUSR | S_IWUSR);
	ftruncate(fileDesc, sizeof(barrier));
	myBarrier = mmap(NULL, sizeof(barrier), PROT_READ | PROT_WRITE, MAP_SHARED, fileDesc, 0);
	
	if(argc!=2)
	{
		printf("zle argumenty\n");
		return 1;
	}

	int N = atoi(argv[1]);
	barrier_init(myBarrier, N);

	printf("Rozpoczynam wyscig %d rund i %d koni\n", N, N);

	for(int i=1;i<=N;i++)
	{
		pid_t myPid = fork();
		if(myPid == 0)
		{
			//dziecko
			for(int j=1;j<=N;j++)
			{
				barrier_wait(myBarrier);
				printf("Runda %d: kon %d dobiegl do mety\n", j, i);
			}

			return 0;
		}
		
	}

	for(int i=0;i<N;i++)
	{
		int status;
		wait(&status);
	}

	printf("Wyscig skonczony\n");
	
	barrier_destroy(myBarrier);
	return 0;
}
	
