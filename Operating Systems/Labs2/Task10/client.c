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
#include <time.h>
#include <stdio.h>

#define max(a,b) (a < b) ? a : b
#define BUFFER_SIZE 128
#define STDOUT 1
#define LISTEN_BACKLOG 64
#define LISTENER_ADDRESS "/tmp/Task10"
#define MAX_CONNECTIONS 256
#define POLL_TIMEOUT 10000
#define BYTES_SERIES 10

char buffer[BUFFER_SIZE];
int sentBytes[BYTES_SERIES];

int makeRandom(int a, int b)
{
    return rand()%(b-a+1) + a;
}

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


int main()
{
    srand(time(NULL));

    int socketDescriptor = socket(AF_UNIX, SOCK_STREAM, 0);

    int retVal;
    struct sockaddr listenerAddress;
    listenerAddress.sa_family = AF_UNIX;
    strcpy(listenerAddress.sa_data, LISTENER_ADDRESS);

    retVal = connect(socketDescriptor, &listenerAddress, sizeof(listenerAddress));
    if(retVal == -1)
    {
        printf("Nie udało się połączyć\n");
        printf("%s\n", strerror(errno));
        return 1;
    }

    int n = BYTES_SERIES;
    for(int i=0;i<n;i++)
    {
        int numBytes = makeRandom(1, BUFFER_SIZE - 1);
        sentBytes[i] = numBytes;
        printf("-> %d\n", numBytes);
        for(int i=0; i<numBytes; i++)
        {
            buffer[i] = '1';
        }
        buffer[numBytes] = 0;

        retVal = send(socketDescriptor, buffer, numBytes + 1, 0);
        if(retVal < 0)
        {
            printf("Nie udało się wysłać serii bajtów nr %d\n", i+1);
            printf("%s\n", strerror(errno));
        }
        printf("Wysłałem serię %d\n", i+1);
    }

    buffer[0] = 0;
    retVal = send(socketDescriptor, buffer, 1, 0);
    if(retVal < 0)
    {
        printf("Nie udało się wysłać ostatniego zerowego bajtu\n");
        printf("%s\n", strerror(errno));
    }

    for(int i=0; i<n; i++)
    {
        retVal = recv(socketDescriptor, buffer, BUFFER_SIZE, 0);
        if(retVal == -1)
        {
            printf("Nie udało się odebrać odpowiedzi %d\n", i+1);
            printf("%s\n", strerror(errno));
        }
        //printf("Wysłałem %d a dostałem ", sentBytes[i]);
        write(STDOUT, buffer, retVal);
        /*int length = itoa(sentBytes[i], buffer, BUFFER_SIZE);
        strcat(buffer, "\n adsd ");
        write(STDOUT, buffer, length + 1);*/

    }
}
