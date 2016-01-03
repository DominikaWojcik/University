#include <unistd.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>

#define BUFFER_SIZE 256
#define TO_READ 23
#define STDOUT 1

char buffer[BUFFER_SIZE];

void itoa(long unsigned int i, char* buffer, size_t size)
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
}

int sendFileDescriptor(int socket, int fileDescriptor)
{
    struct msghdr messageHeader = {0};
    struct cmsghdr* controlMessageHeader;
    char buf[CMSG_SPACE(sizeof(fileDescriptor))];

    messageHeader.msg_control = buf;
    messageHeader.msg_controllen = sizeof(buf);

    controlMessageHeader = CMSG_FIRSTHDR(&messageHeader);
    controlMessageHeader->cmsg_level = SOL_SOCKET;
    controlMessageHeader->cmsg_type = SCM_RIGHTS;
    controlMessageHeader->cmsg_len = CMSG_LEN(sizeof(fileDescriptor));

    *((int*) CMSG_DATA(controlMessageHeader)) = fileDescriptor;

    messageHeader.msg_controllen = controlMessageHeader->cmsg_len;

    return sendmsg(socket, &messageHeader, 0);
}

int receiveFileDescriptor(int socket, int* fileDescriptor)
{
    struct msghdr messageHeader = {0};

    char buf[BUFFER_SIZE];
    messageHeader.msg_control = buf;
    messageHeader.msg_controllen = sizeof(buf);

    /*char iovbuf[BUFFER_SIZE];
    struct iovec headerIovec;
    headerIovec.iov_base = iovbuf;
    headerIovec.iov_len = sizeof(iovbuf);
    messageHeader.msg_iov = &headerIovec;
    messageHeader.msg_iovlen = 1;*/

    if(recvmsg(socket, &messageHeader, 0) == -1)
    {
        return -1;
    }

    struct cmsghdr* controlMessageHeader = CMSG_FIRSTHDR(&messageHeader);
    *fileDescriptor = *((int*) CMSG_DATA(controlMessageHeader));

    return 0;
}

int main()
{
    int socketDescriptors[2];
    if(socketpair(AF_UNIX, SOCK_DGRAM, 0, socketDescriptors) == -1)
    {
        strcpy(buffer, "Nie można stworzyć gniazd\n");
        write(STDOUT, buffer, BUFFER_SIZE);
        return 1;
    }

    pid_t childPid;

    if((childPid = fork()) == 0)
    {
        //Dziecko wysyłające
        close(socketDescriptors[1]);

        int fileDescriptor = open("file", O_RDONLY);
        int myPid = getpid();
        char readBuffer[BUFFER_SIZE];

        read(fileDescriptor, readBuffer, TO_READ);
        itoa(myPid, buffer, BUFFER_SIZE);
        strcat(buffer, ": ");
        strcat(buffer, readBuffer);
        strcat(buffer, "\n");
        write(STDOUT, buffer, BUFFER_SIZE);

        int kappa;
        if((kappa = sendFileDescriptor(socketDescriptors[0], fileDescriptor)) == -1)
        {
            strcpy(buffer, "Nie udało się wysłać deskryptora pliku\n");
            write(STDOUT, buffer, BUFFER_SIZE);

            strcpy(buffer, strerror(errno));
            strcat(buffer, "\n\0");
            write(STDOUT, buffer, BUFFER_SIZE);

            return 1;
        }

        close(fileDescriptor);
        close(socketDescriptors[0]);

        return 0;
    }

    if((childPid = fork()) == 0)
    {
        //Dziecko odbierające
        close(socketDescriptors[0]);

        int myPid = getpid();
        char readBuffer[BUFFER_SIZE];
        int fileDescriptor;

        if(receiveFileDescriptor(socketDescriptors[1], &fileDescriptor) == -1)
        {
            strcpy(buffer, "Nie udało się odebrać deskryptora pliku\n");
            write(STDOUT, buffer, BUFFER_SIZE);

            strcpy(buffer, strerror(errno));
            strcat(buffer, "\n\0");
            write(STDOUT, buffer, BUFFER_SIZE);

            return 1;
        }

        read(fileDescriptor, readBuffer, TO_READ);
        itoa(myPid, buffer, BUFFER_SIZE);
        strcat(buffer, ": ");
        strcat(buffer, readBuffer);
        strcat(buffer, "\n");
        write(STDOUT, buffer, BUFFER_SIZE);

        close(fileDescriptor);
        close(socketDescriptors[1]);

        return 0;
    }

    close(socketDescriptors[0]);
    close(socketDescriptors[1]);

    int status;

    childPid = wait(&status);
    itoa(childPid, buffer, BUFFER_SIZE);
    strcat(buffer, " się zakończył\n");
    write(STDOUT, buffer, BUFFER_SIZE);

    childPid = wait(&status);
    itoa(childPid, buffer, BUFFER_SIZE);
    strcat(buffer, " się zakończył\n");
    write(STDOUT, buffer, BUFFER_SIZE);

    return 0;
}
