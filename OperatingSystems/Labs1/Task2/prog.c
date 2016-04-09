/* Jarosław Dzikowski 273233

	
	
	
*/
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>
#define BUF_SIZE 128

extern char** environ;

char buf[BUF_SIZE];
char* errorMsg = "Dostepne argumenty:\na - wypisuje srodowisko i costam jeszcze\nb - costam robi z plikami";

int main(int argc, char* argv[])
{
	if(argc < 2)
	{
		printf("%s\n", errorMsg);
		return 1;
	}

	if(argv[1][0] == 'a')
	{
		printf("ENVIRONMENT:\n");
		for(int i=0; environ[i]!=NULL; i++)
		{
			printf("%d: %s\n",i,environ[i]);
		}
		printf("\n");

		printf("CURRENT WORKING DIRECTORY:\n");
		getcwd(buf, BUF_SIZE);
		printf("%s\n",buf);

		pid_t childPid = fork();

		if(childPid == 0)
		{
			// Część programu dziecka
			sleep(1.0);

			printf("DZIECKO HOME: %s\n", getenv("HOME"));
			getcwd(buf,BUF_SIZE);
			printf("DZIECKO CWD: %s\n", buf);
		}
		else
		{
			// Część programu ojca
			printf("OJCIEC stary HOME: %s\n", getenv("HOME"));
			setenv("HOME", "/home/dziku/pracownia1", 1);

			getcwd(buf,BUF_SIZE);
			printf("OJCIEC stary CWD: %s\n", buf);
			if(chdir("/home/dziku/pracownia1")==-1)
			{
				printf("Nie udalo sie zmienic katalogu %s\n", strerror(errno));
			}

			printf("OJCIEC nowy HOME: %s\n", getenv("HOME"));
			getcwd(buf,BUF_SIZE);
			printf("OJCIEC nowy CWD: %s\n", buf);
		}

	}
	else if(argv[1][0] == 'b')
	{
		int fileDescriptor = open("sharedfile", O_RDONLY);

		if(fileDescriptor == -1) printf("%s\n", "Coś nie pykło");

		pid_t childPid = fork();

		if(childPid == 0)
		{
			// Część programu dziecka
			printf("Dziecko pid: %d\n",getpid());
			sleep(1.0);
			printf("Dziecko: offset %lu\n", lseek(fileDescriptor, 0, SEEK_CUR));

			sleep(5.0);
		}
		else
		{
			// Część programu ojca
			// Nie zamknie dziecku
			// Sprawdzam lsof'em
			
			printf("Ojciec pid: %d\n",getpid());
			printf("Ojciec: offset %lu\n", lseek(fileDescriptor, 0, SEEK_CUR));
			printf("Ojciec wczytał %ld bajtow\n", read(fileDescriptor, buf, 3));
			printf("Ojciec wczytał %s z pliku\n", buf);
			printf("Ojciec: offset %lu\n", lseek(fileDescriptor, 0, SEEK_CUR));
			sleep(2.0);

			close(fileDescriptor);
			printf("Zamykam plik\n");

			char* args[] = {"/usr/bin/lsof", "-c", "prog", NULL};
			execve(args[0], args, environ);
		}
	}
	else
	{
		printf("%s\n", errorMsg);
		return 1;
	}
	


	return 0;
}

