#include<stdio.h>
#include<pthread.h>
#include<stdlib.h>
#include<sys/time.h>
#include<time.h>

#define INSERT 10
#define SEARCH 10
#define DELETE 3 

#define MIN_SLEEP 1000
#define MAX_SLEEP 1000
#define MICROSECOND 1000

int makeRandom(int a, int b)
{
	return rand()%(b-a+1) + a;
}

typedef struct nd
{
	int value;
	struct nd *next, *prev;
} Node;

void initializeNode(Node* node, int value)
{
	node->value = value;
	node->next = NULL;
	node->prev = NULL;
}

typedef struct
{
	int size;
	Node* start;
} List;

List list;

void initializeList(List* l)
{
	l->size = 0;
	l->start = NULL;
}


void insertElement(List* l, int value)
{
	Node* newNode = calloc(1, sizeof(Node));
	initializeNode(newNode, value);

	if(l->size == 0)
		l->start = newNode;
	else
	{
		Node* node = l->start;
		while(node->next != NULL)
			node = node->next;
		node->next = newNode;
		newNode->prev = node;
	}
	l->size++;
}


int deleteElement(List* l, int pos)
{
	int retVal;
	Node* node = l->start;
	
	while(pos > 0)
	{
		pos--;
		node = node->next;
	}
	retVal = node->value;

	if(node == l->start)
	{
		l->start = node->next;
		if(node->next != NULL)
			node->next->prev = NULL;
	}
	else if(node->next == NULL)
	{
		node->prev->next = NULL;
	}
	else
	{
		node->next->prev = node->prev;
		node->prev->next = node->next;
	}

	l->size--;
	free(node);

	return retVal;
}

int searchElement(List* l, int value)
{
	int pos = 0;
	Node* node = l->start;

	while(node != NULL) 
	{
		if(node->value == value)
			return pos;
		pos++;
		node = node->next;
	}

	return -1;
}

void destroyList(List* l)
{
	Node *node = l->start, *newNode = NULL;
	while(node != NULL && node->next != NULL)
		node = node->next;
	while(node != NULL)
	{
		newNode = node->prev;
		free(node);
		node = newNode;
	}
}

//////////////////
//MONITOR
//////////////////
typedef struct
{
	int searching, inserting, deleting;
	pthread_mutex_t mutex;
	pthread_cond_t canSearch, canInsert, canDelete;
} Monitor;

Monitor monitor;

void initializeMonitor(Monitor* m)
{
	m->searching = 0;
	m->inserting = 0;
	m->deleting = 0;

	pthread_mutex_init(&m->mutex, NULL);

	pthread_cond_init(&m->canSearch, NULL);
	pthread_cond_init(&m->canInsert, NULL);
	pthread_cond_init(&m->canDelete, NULL);
}

void destroyMonitor(Monitor* m)
{
	m->searching = 0;
	m->inserting = 0;
	m->deleting = 0;

	pthread_mutex_destroy(&m->mutex);

	pthread_cond_destroy(&m->canSearch);
	pthread_cond_destroy(&m->canInsert);
	pthread_cond_destroy(&m->canDelete);
}

void enterSearch(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	while(m->deleting > 0)
	{
		pthread_cond_wait(&m->canSearch, &m->mutex);
	}
	
	m->searching++;

	pthread_mutex_unlock(&m->mutex);
}

void exitSearch(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	m->searching--;
	if(m->searching == 0 && m->inserting == 0)
		pthread_cond_signal(&m->canDelete);

	pthread_mutex_unlock(&m->mutex);
}

void enterInsert(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	while(m->deleting > 0 || m->inserting > 0)
	{
		pthread_cond_wait(&m->canInsert, &m->mutex);
	}
	
	m->inserting++;

	pthread_mutex_unlock(&m->mutex);
}

void exitInsert(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	m->inserting--;

	if(m->searching == 0)
		pthread_cond_signal(&m->canDelete);
	pthread_cond_signal(&m->canInsert);

	pthread_mutex_unlock(&m->mutex);
}

void enterDelete(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	while(m->deleting > 0 || m->inserting > 0 || m->searching > 0 || list.size == 0)
	{
		pthread_cond_wait(&m->canDelete, &m->mutex);
	}
	
	m->deleting++;

	pthread_mutex_unlock(&m->mutex);
}

void exitDelete(Monitor* m)
{
	pthread_mutex_lock(&m->mutex);

	m->deleting--;
	
	pthread_cond_signal(&m->canSearch);
	pthread_cond_signal(&m->canInsert);
	pthread_cond_signal(&m->canDelete);

	pthread_mutex_unlock(&m->mutex);
}

//////////////////////////////
//WATKI search, insert, delete
//////////////////////////////

void* search()
{
	while(1)
	{
		int value = makeRandom(1, 5);
		
		enterSearch(&monitor);
		
		int pos =searchElement(&list, value);
		printf("Znaleziono %d na pozycji %d\n", value, pos);

		exitSearch(&monitor);

		long randTime = makeRandom(MIN_SLEEP, MAX_SLEEP) * MICROSECOND;
		struct timespec tmspc;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;

		nanosleep(&tmspc, NULL);
	}

	return NULL;
}

void* insert()
{
	while(1)
	{
		int value = makeRandom(1, 5);

		enterInsert(&monitor);
		
		insertElement(&list, value);
		printf("Wstawiono %d\n", value);

		exitInsert(&monitor);
		
		long randTime = makeRandom(MIN_SLEEP, MAX_SLEEP) * MICROSECOND;
		struct timespec tmspc;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;

		nanosleep(&tmspc, NULL);
	}
	return NULL;
}

void* delete()
{
	while(1)
	{
		enterDelete(&monitor);

		int pos = makeRandom(0, list.size - 1);
		int value = deleteElement(&list, pos);
		printf("Usunięto %d na pozycji %d\n", value, pos);

		exitDelete(&monitor);

		long randTime = makeRandom(MIN_SLEEP, MAX_SLEEP) * MICROSECOND;
		struct timespec tmspc;
		tmspc.tv_sec = 0;
		tmspc.tv_nsec = randTime;

		nanosleep(&tmspc, NULL);
	}
	return NULL;
}




pthread_t* threadInfo;

int main()
{
	srand(time(NULL));
	
	initializeList(&list);
	initializeMonitor(&monitor);

	threadInfo = calloc(SEARCH + INSERT + DELETE, sizeof(pthread_t));
	
	for(int i=0;i<SEARCH;i++)
	{
		pthread_create(&threadInfo[i], NULL, search, NULL);
	}

	for(int i=SEARCH;i<SEARCH + INSERT;i++)
	{
		pthread_create(&threadInfo[i], NULL, insert, NULL);
	}

	for(int i=SEARCH + INSERT;i<SEARCH + INSERT + DELETE;i++)
	{
		pthread_create(&threadInfo[i], NULL, delete, NULL);
	}

	for(int i=0;i<SEARCH + INSERT + DELETE; i++)
	{
		void* status;
		pthread_join(threadInfo[i], &status);
	}

	destroyList(&list);
	destroyMonitor(&monitor);
	free(threadInfo);

	return 0;
}
