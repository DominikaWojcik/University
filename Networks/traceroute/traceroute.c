/*
	Sieci komputerowe 2016
	Zadanie: Traceroute
	Autor: Jarosław Dzikowski
	Indeks: 273233
	Grupa: Piątek 10-12
*/

#include <stdio.h>
#include <stdlib.h>
#include "networking.h"
#include <errno.h>
#include <string.h>

int ProcessInput(char* input)
{
	int dots=0,digits=0,num=0;
	for(unsigned int i = 0; input[i] != '\0'; i++)
	{
		if(input[i] >= '0' && input[i] <= '9')
		{
			digits++;
			num *= 10;
			num += (int)(input[i] - '0');
			if(digits > 3 || num  >= 256)
			{
				fprintf(stderr, "Invalid IP address.\n");
				return -1;
			}
		}
		else if(input[i] == '.')
		{
			if(digits == 0)
			{
				fprintf(stderr, "Invalid IP address.\n");
				return -1;
			}
			dots++;
			digits = 0;
			num = 0;
		}
		else 
		{
			fprintf(stderr, "Invalid IP address.\n");
			return -1;
		}
	}
	return 0;
}


int main(int argc, char* argv[])
{
	if(argc > 2)
	{
		printf("Too many arguments.\n");
		return EXIT_FAILURE;
	}
	else if(argc == 1)
	{
		printf("IP address not given.\n");
		return EXIT_FAILURE;
	}

	if(ProcessInput(argv[1]) < 0)
	{
		return EXIT_FAILURE;			
	}

	if(TraceRoute(argv[1]) < 0)
	{
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
