/* Jarosław Dzikowski 273233
*  Argumenty:
*	a - wypisuje pidy
*	b - robi zombie
*	c - obsluguje SIGCHLD, tworzy zombie i zabija go dostajac SIGCHLD
*/
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <signal.h>

void handleSigchld(int sig)
{
	int status;
	pid_t zombie;
	while((zombie = waitpid(-1, &status, WNOHANG)) > 0)
	{
		printf("Zabilem zombie o pid %d\n", zombie);
	}
}

int main(int argc, char* argv[], char* envp[])
{
	if(argc !=2)
	{
		printf("\nParametry:\na - wypisuje info\nb - tworzy proc zombie\nc - zapobiega tworzeniu zombie\n");
		return 1;
	}

	if(argv[1][0] == 'a')
	{
		pid_t pid = getpid();
		pid_t ppid = getppid();
		pid_t sid = getsid(pid);
		pid_t pgid = getpgrp();
		printf("pid = %d\nppid = %d\nsid = %d\npgid = %d\n",pid,ppid,sid,pgid);

		char* args[] = {"/bin/ps",
						 "-o", "pid",
						  "-o", "ppid",
						   "-o", "sid",
						    "-o", "pgid",
						     "-o", "comm", NULL};
		execve(args[0], args, envp);
		printf("Nie udalo sie wlaczyc ps\n");
		return 1;
	}
	else if(argv[1][0] == 'b')
	{
		pid_t childpid;  

		if((childpid = fork()) == 0)
		{
			printf("Jestem dzieckiem, koncze sie\n");
			return 0;
		}
		else
		{
			printf("\nStowrzylem dziecko o pid = %d\n",childpid);
		}
		
		
		char* args[] = {"/bin/ps", "-f", NULL};
		execve(args[0], args, envp);
		printf("Nie udalo sie odpalic ps\n");
		return 1;
	}
	else if(argv[1][0] == 'c')
	{

		struct sigaction sigchldAction;
		sigchldAction.sa_handler = handleSigchld; 
		sigaction(SIGCHLD, &sigchldAction, NULL);

		pid_t childpid;  

		if((childpid = fork()) == 0)
		{
			printf("Jestem dzieckiem, koncze sie\n");
			return 0;
		}

		printf("\nStowrzylem dziecko o pid = %d\n", childpid);
		
		sleep(1.0);
		char* args[] = {"/bin/ps", "-f", NULL};
		execve(args[0], args, envp);
		printf("Nie udalo sie wlaczyc ps\n");
		return 1;
	}
	else
	{
		printf("\nParametry:\na - wypisuje info\nb - tworzy proc zombie\nc - zapobiega tworzeniu zombie\n");
		return 1;
	}

	return 0;
}

