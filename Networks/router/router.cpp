#include <unistd.h>
#include <string>
#include <cstdlib>
#include <signal.h>
#include <vector>
#include <cstdio>
#include "networking.h"
#include "utils.h"

using namespace std;

void handleSigint(int sigint)
{
	Cleanup();
	exit(128 + sigint);
}

void RegisterSigintHandler()
{
	struct sigaction sigintAction;
	sigintAction.sa_handler = handleSigint;
	sigaction(SIGINT, &sigintAction, NULL);
}

int main()
{
	if(!ProcessInput())
	{
		fprintf(stderr, "Niepoprawne dane wejściowe\n");
		return 1;
	}
	printf("Wczytano dane wejściowe\n");

	if(!Initialize())
	{
		fprintf(stderr, "Nie udało się zainicjalizować struktury danych\n");
		return 1;
	}
	printf("Poprawnie zainicjalizowano dane\n");

	//Rejestruję obsługę sygnału SIGINT, by poprawnie zamykać gniazda
	RegisterSigintHandler();
	printf("Zarejestrowano obsługę sygnału SIGINT\n");

	while(true)
	{
		PrintDV();
			
		if(!BroadcastDV())
		{
			fprintf(stderr, "Błąd przy rozsyłaniu wektora odległości\n");
			return 1;
		}

		if(!ReceiveDVs())
		{
			fprintf(stderr, "Błąd przy odbieraniu wektorów odległości\n");
			return 1;
		}

		CheckTimeouts();

		sleep(TURN);
	}
		
	return 0;
}
