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
#include "utils.h"
#include <errno.h>
#include <string.h>


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
