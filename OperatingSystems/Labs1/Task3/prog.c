/* Jarosław Dzikowski 273233

	Może popełnic sudoku: 
		./prog /usr/bin/pkill prog

	Ciekawe, ze wait zwraca 0 jesli wszystko w porządku
	nr sygnału, jesli potomek zakonczony sygnalem
	256 * exit code programu
	
*/
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>

char* errorMsg = "Nie podano argumentow wywolania";

int main(int argc, char* argv[], char* envp[])
{
	if(argc == 0)
	{
		printf("%s\n", errorMsg);
		return 1;
	}

	pid_t childPid = fork();

	if(childPid == 0)
	{
		//Jestem dzieckiem
		printf("Próbuje wywołać program ");
		for(int i=1; argv[i]!=NULL; i++)
			printf("%s ",argv[i]);
		printf("\n");

		execve(argv[1], argv+1, envp);
		printf("Execve sie nie powiodlo\n");
		return 2;
	}
	
	int status = -1;
	childPid = wait(&status);
	//Jesli normalny kod wyjscia to pomnozony przez 256
		
	if(status > 0 && status < 256)
		printf("Program zakonczony sygnalem %d - %s\n", status, strsignal(status));
	else
		printf("Program zakonczony kodem %d\n", status/256);
	


	return 0;
}

