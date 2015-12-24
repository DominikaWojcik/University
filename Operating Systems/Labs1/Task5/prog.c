/* Jarosław Dzikowski 273233

	Piate zadanko
	
	
*/
#define _GNU_SOURCE
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <errno.h>
#define BUF_SIZE 128

int savedIn, savedOut;
//Typ ma być 'r' lub 'w' - innego nie przewiduje
int mypopen(char* command, char* arguments[], 
				char* environment[], const char* type)
{
	//Te rury sa do raportowania bledu execa
	int pipeDescriptors[2];
	//pipe2(pipeDescriptors, FD_CLOEXEC | O_NONBLOCK);
	if(pipe(pipeDescriptors) == -1)
	{
		return -1;
	}
	fcntl(pipeDescriptors[1], F_SETFD, FD_CLOEXEC);

	//Te sluza do komunikacji
	int fileDescriptors[2];
	if(pipe(fileDescriptors) == -1)
	{
		return -1;
	}

	int readDescriptor = fileDescriptors[0];
	int writeDescriptor = fileDescriptors[1];

	int childPid = fork();

	if(childPid == 0)
	{
		//Dziecko
		if(type[0] == 'r')
		{
			close(readDescriptor);
			savedOut = dup(STDOUT_FILENO);
			dup2(writeDescriptor, STDOUT_FILENO);
		}
		else if(type[0] == 'w')
		{
			close(writeDescriptor);
			savedOut = dup(STDIN_FILENO);
			dup2(readDescriptor, STDIN_FILENO);
		}

		close(pipeDescriptors[0]);
		//close(pipeDescriptors[1]);

		execve(command, arguments, environment);
		char* execveError[] = {"E"};
		write(pipeDescriptors[1], execveError, 1);
		
		exit(EXIT_FAILURE);
	}
	else
	{
		//Rodzic
		if(type[0] == 'r')
		{
			close(writeDescriptor);
			savedIn = dup(STDIN_FILENO);
			dup2(readDescriptor, STDIN_FILENO);
		}
		else if(type[0] == 'w')
		{
			close(readDescriptor);
			savedOut = dup(STDOUT_FILENO);
			dup2(writeDescriptor, STDOUT_FILENO);
		}

		int readBytes=0;
		int error;
		close(pipeDescriptors[1]);

		//Wczytuje blad
		readBytes = read(pipeDescriptors[0], &error, sizeof(error));
		if(readBytes > 0)
			return -1;
		close(pipeDescriptors[0]);
	}

	return childPid;
}

int mypclose(int pid, char* type)
{
	if(type[0]=='w')
	{
		close(STDOUT_FILENO);
		dup2(savedOut, STDOUT_FILENO);
	}
	else if(type[0]=='r')
	{
		close(STDIN_FILENO);
		dup2(savedIn, STDIN_FILENO);
	}

	kill(pid, SIGHUP);

	return 0;
}


int main(int argc, char* argv[], char* envp[])
{

	char tolower[] = "AAdddAAAdsdsd234SDSDSss\ndadasZZDsada23\n";
	char* args[] = {"tolower", NULL};
	int tolowerPid;
	
	if((tolowerPid = mypopen(args[0], args, envp, "w")) == -1)
	{
		printf("Nie udalo sie polaczyc z tolower\n");
		return 1;
	}
	for(int i=0;i<100000;i++)
		printf("%s\n", tolower);
	fflush(stdout);
	
	mypclose(tolowerPid, "w");
	printf("Tolower zamkniety\n");

	printf("Uruchomie ls\n");
	char* args2[] = {"/bin/ls",NULL};
	int lsPid = mypopen(args2[0], args2, envp, "r");

	char buf[BUF_SIZE];
	while(scanf("%s", buf)>0)
	{
		printf("Dostalem %s\n",buf);
	}

	mypclose(lsPid, "r");

	return 0;
}

