#include <poll.h>
#include <unistd.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <stdio.h>

#define max(a,b) (a < b) ? a : b
#define BUFFER_SIZE 128
#define STDOUT 1
#define LISTEN_BACKLOG 64
#define LISTENER_ADDRESS "/Task10"
#define MAX_CONNECTIONS 256
#define POLL_TIMEOUT 3000

//Kolejka
typedef struct
{
	int buf[BUFFER_SIZE];
	int nextIn, nextOut, size;
} queue;

void initialize(queue* q)
{
	q->size = 0;
	q->nextIn = 0;
	q->nextOut = 0;
}

void push(queue* q, int n)
{
	if(q->size < BUFFER_SIZE)
	{
		q->buf[q->nextIn] = n;
		q->size++;
		q->nextIn = (q->nextIn + 1) % BUFFER_SIZE;
	}
}

int front(queue* q)
{
	if(q->size > 0)
	{
		return q->buf[q->nextOut];
	}

	return -1;
}

void pop(queue* q)
{
	if(q->size > 0)
	{
		q->size--;
		q->nextOut++;
	}
}
/////

char buffer[BUFFER_SIZE];

int listener;

struct pollfd descriptors[MAX_CONNECTIONS];
int descriptorCount;
int pollRetVal;

int byteCounter[MAX_CONNECTIONS];
int lastBlockSize[MAX_CONNECTIONS];
queue sendQueue[MAX_CONNECTIONS];

int itoa(long unsigned int i, char* buffer, size_t size)
{
	unsigned int index = 0;
	while(i>0 && index < size)
	{
		buffer[index++] = i%10 + '0';
		i /= 10;
	}

	if(index == 0 && index < size)
		buffer[index++] = '0';

	buffer[index] = 0;

	//Teraz sobie zamienie miejscami literki
	--index;
	for(unsigned int i=0; i <= index/2; i++)
	{
		char tmp = buffer[i];
		buffer[i] = buffer[index-i];
		buffer[index-i] = tmp;
	}

	return index+1;
}

void acceptNewConnections(int* socketsToHandle)
{
	if(descriptors[0].revents != POLLIN)
	{
		return;
	}

	(*socketsToHandle)--;

	//accept connections
	int retVal=0, searchPos = 1;
	do
	{
		retVal = accept(descriptors[0].fd, NULL, NULL);
		if(retVal < 0 && errno != EWOULDBLOCK && errno != EAGAIN)
		{
			printf("Błąd na accepcie\n");
			printf("%s\n", strerror(errno));

			unlink(LISTENER_ADDRESS);
			exit(1);
		}

		if(retVal < 0) continue;

		while(searchPos < MAX_CONNECTIONS)
		{
			if(descriptors[searchPos].fd < 0)
			{
				descriptors[searchPos].fd = retVal;
				descriptors[searchPos].events = POLLIN | POLLOUT;
				descriptors[searchPos].revents = 0;
				byteCounter[searchPos] = 0;
				lastBlockSize[searchPos] = -1;
				descriptorCount = max(descriptorCount, searchPos + 1);
				initialize(&sendQueue[searchPos]);

				searchPos++;
				printf("Nowe połączenie\n");
				break;
			}
			searchPos++;
		}


	} while(retVal >= 0 && searchPos < MAX_CONNECTIONS);
}

void receiveAndSendData(int* socketsToHandle)
{
	for(int i=1; i<descriptorCount && *socketsToHandle > 0; i++)
	{
		if(descriptors[i].revents == 0) continue;

		(*socketsToHandle)--;

		if((descriptors[i].revents & POLLIN) && byteCounter[i] != -1)
		{
			//Odczytujemy dane póki się da
			int retVal;

			do
			{
				retVal = recv(descriptors[i].fd, buffer, BUFFER_SIZE, 0);
				if(retVal < 0 && errno != EWOULDBLOCK && errno != EAGAIN)
				{
					printf("Błąd przy odbieraniu danych\n");
					printf("%s\n", strerror(errno));

					unlink(LISTENER_ADDRESS);
					exit(EXIT_FAILURE);
				}

				if(retVal == 0)
				{
					//Zerwano połączenie
					close(descriptors[i].fd);
					descriptors[i].fd = -1;
					descriptors[i].events = 0;
					descriptors[i].revents = 0;
					byteCounter[i] = 0;
					lastBlockSize[i] = -1;

					printf("Zerwano połączenie\n");
				}

				for(int j=0; j<retVal && byteCounter[i]>=0; j++)
				{
					if(buffer[j] == 0)
					{
						if(lastBlockSize[i] == 0)
						{
							//Koniec transmisji
							byteCounter[i] = -1;
						}
						else
						{
							lastBlockSize[i] = byteCounter[i];
							push(&sendQueue[i], byteCounter[i]);
							byteCounter[i] = 0;
						}
					}
					else byteCounter[i]++;
				}


			} while(retVal >= 0 && byteCounter[i] >= 0);
		}

		if(descriptors[i].revents & POLLOUT)
		{
			//Wysyłamy dane póki się da
			int retVal;

			do
			{
				if(sendQueue[i].size == 0) break;

				int toSend = front(&sendQueue[i]);
				int length = itoa(toSend, buffer, BUFFER_SIZE);
				strcat(buffer, "\n");
				length++;

				retVal = send(descriptors[i].fd, buffer, length, 0);
				if(retVal < 0 && errno != EWOULDBLOCK && errno != EAGAIN)
				{
					printf("Błąd podczas wysyłania\n");
					printf("%s\n", strerror(errno));

					unlink(LISTENER_ADDRESS);
					exit(EXIT_FAILURE);
				}

				if(retVal >= 0)
				{
					pop(&sendQueue[i]);
				}

			} while(sendQueue[i].size > 0 && retVal >= 0);

			if(byteCounter[i] == -1 && sendQueue[i].size == 0)
			{
				//Zerwij połączenie
				close(descriptors[i].fd);
				descriptors[i].fd = -1;
				descriptors[i].events = 0;
				descriptors[i].revents = 0;
				lastBlockSize[i] = -1;

				printf("Koniec połączenia - transmisja zakończona\n");
			}
		}

	}
}

void handleSigint(int sigint)
{
	for(int i=0; i<descriptorCount; i++)
	{
		if(descriptors[i].fd >= 0)
		{
			close(descriptors[i].fd);
		}
	}

	unlink(LISTENER_ADDRESS);

	int length;
	length = snprintf(buffer, BUFFER_SIZE, "Zamknięto gniazda oraz usunięto adres gniazda nasłuchującego\n");
	write(STDOUT, buffer, length);
	length = snprintf(buffer, BUFFER_SIZE, "Program zakończony sygnałem SIGINT\n");
	write(STDOUT, buffer, length);

	exit(128 + sigint);
}


int main()
{
	//Zarejestruj obsługę SIGINT
	struct sigaction sigintAction;
	sigintAction.sa_handler = handleSigint;
	sigaction(SIGINT, &sigintAction, NULL);

	printf("Zarejestrowowano obsługę sygnału SIGINT\n");

	//Stwórz nieblokujące gniazdo
	listener = socket(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0);
	if(listener == -1)
	{
		printf("Nie udało się stworzyć gniazda\n");
		printf("%s\n", strerror(errno));
		return 1;
	}

	printf("Stworzono gniazdo nasłuchujące\n");

	//Przypisz mu adres
	struct sockaddr listenerAddress;
	listenerAddress.sa_family = AF_UNIX;
	strcpy(listenerAddress.sa_data, LISTENER_ADDRESS);
	if(bind(listener, &listenerAddress, sizeof(listenerAddress)) == -1)
	{
		printf("Nie udało się przypisać gniazdu adresu\n");
		printf("%s\n", strerror(errno));
		return 1;
	}

	printf("Przypisano gniazdu adres\n");

	//Zacznij nasłuchiwać
	if(listen(listener, LISTEN_BACKLOG) == -1)
	{
		printf("Nie udało się nasłuchiwać\n");
		printf("%s\n", strerror(errno));

		unlink(LISTENER_ADDRESS);
		return 1;
	}

	printf("Rozpoczęto nasłuchiwanie\n");

	//Zainicjalizuj strukturę do poll
	descriptorCount = 1;
	descriptors[0].fd = listener;
	descriptors[0].events = POLLIN;
	for(int i=1; i<MAX_CONNECTIONS; i++)
	{
		descriptors[i].fd = -1;
		lastBlockSize[i] = -1;
	}

	printf("Zainicjalizowano struktury do poll\n");

	while(1)
	{
		pollRetVal = poll(descriptors, descriptorCount, POLL_TIMEOUT);
		if(pollRetVal > 0)
		{
			acceptNewConnections(&pollRetVal);
			receiveAndSendData(&pollRetVal);
		}
		else if(pollRetVal < 0 && errno != EINTR)
		{
			printf("Poll się nie powiódł\n");
			printf("%s\n", strerror(errno));

			unlink(LISTENER_ADDRESS);
			return 1;
		}
	}

	return 0;
}
