#include<stdio.h>
#include<sys/wait.h>
#include<unistd.h>
#include<fcntl.h>
#include<time.h>
#include<sys/stat.h>
#include<mqueue.h>
#include<stdlib.h>
#include<errno.h>
#include<pthread.h>

#define SIGNALS 10
#define MAX_MESSAGES 10
#define MESSAGE_SIZE 10

typedef struct
{
	mqd_t messageQueue;
	char* name;
} cs_t;

cs_t* countingSem;
pthread_t* threadInfo;

cs_t* cs_open(char* name, int value)
{
	cs_t* newSem = calloc(1, sizeof(cs_t));
	mqd_t messageQueue;
	messageQueue = mq_open(name, O_RDWR);

	//jeśli kolejka nie została stworzona
	if(messageQueue == -1 && errno == ENOENT)
	{
		//tworzę i inicjalizuję
		printf("Kolejka nie istaniala, więc tworzę nową\n");
		struct mq_attr attr;
		attr.mq_flags = 0;
		attr.mq_maxmsg = MAX_MESSAGES;
		attr.mq_msgsize = MESSAGE_SIZE;
		attr.mq_curmsgs = 0;

		messageQueue = mq_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR, &attr);
		
		if(messageQueue == -1)
		{
			printf("Nie udało się stworzyć kolejki \n");
			switch(errno)
			{
				case ENOENT:
					printf("Errno: ENOENT\n");
					break;
				case EEXIST:
					printf("Errno: Kolejka juz istnieje\n");
					break;
				case EACCES:
					printf("Errno: Nie mam uprawnien albo nazwa ma wiecej niz jeden slash\n");
					break;
				case EINVAL:
					printf("Errno: EINVAL\n");
					break;
				default: 
					printf("Errno: %d\n", errno);
					break;

			}
		}
		
		//inicjalizuje wartość w semaforze
		for(int i=0; i<value; i++)
		{
			mq_send(messageQueue, "a", 1, 1);
		}
	}
	else
	{
		printf("Kolejka istniała - trzeba zmienić jej nazwe!\n");
	}

	newSem->messageQueue = messageQueue;
	newSem->name = name;

	return newSem;
}

void cs_wait(cs_t* sem)
{
	char buffer[MESSAGE_SIZE];
	unsigned priority;
	int ret = mq_receive(sem->messageQueue, buffer, MESSAGE_SIZE, &priority);
	if(ret == -1)
	{
		printf("Czekanie nie powiodło się\n");
		if(errno == EAGAIN)
		{
			printf("errno EAGAIN\n");
		}
	}
}

void cs_post(cs_t* sem)
{
	mq_send(sem->messageQueue, "a", 1, 1);
}

void cs_close(cs_t* sem)
{
	mq_unlink(sem->name);
	mq_close(sem->messageQueue);
	free(sem);
}

//////////////////

void* waiting()
{
	for(int waitCnt = 1; waitCnt<= SIGNALS; waitCnt++)
	{
		cs_wait(countingSem);
		printf("Przeczekalem już %d razy\n", waitCnt);
	}
	return NULL;
}

void* signaling()
{
	for(int i=0; i<SIGNALS; i++)
	{
		cs_post(countingSem);
	}
	return NULL;
}


int main()
{
	srand(time(NULL));

	char name[32];
	sprintf(name, "/%d", rand());

	countingSem = cs_open(name, 0);

	threadInfo = calloc(2, sizeof(pthread_t));
	pthread_create(&threadInfo[0], NULL, waiting, NULL);
	pthread_create(&threadInfo[1], NULL, signaling, NULL);

	void* retVal;
	pthread_join(threadInfo[0], &retVal);
	pthread_join(threadInfo[1], &retVal);

	cs_close(countingSem);
	free(threadInfo);

	return 0;
}
