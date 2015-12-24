// brak argumentow - mieli sie w nieskonczonosc
// jakies argumenty - zwraca 1
#include <stdio.h>
#include <unistd.h>

int main(int argc, char* argv[])
{
	printf("Pid helpera: %d\n",getpid());
	if(argc > 1)
	{
		return 1;
	}

	while(1)
	{

	}

	return 0;
	
}