#include "state.h"
#include "ai.h"
#include <iostream>
#include <vector>

GameState currentState;
int player1;


int main()
{
	std::cout << "CONNECT FOUR\n";
	while(true)
	{
		std::cout << "Wybierz gracza (A/B). Pamiętaj, że gracz A zaczyna.\n";
		char pickedPlayer;
		std::cin >> pickedPlayer;
		if(pickedPlayer == 'B') player1 = GameState::B;
		else player1 = GameState::A;
		currentState = GameState();

		do
		{
			std::cout << "Aktualny stan gry:" << evaluate(currentState) << "\n" << currentState << "\n";	
			if(currentState.turn == player1)
			{
				std::cout << "Do której kolumny wrzucić żeton? [1 - 7], 0 : auto\n";
				int chosenColumn;
				do
				{
					std::cin >> chosenColumn;
				}
				while(chosenColumn != 0 && !IsValidMove(currentState, chosenColumn));

				if(chosenColumn != 0) 
				{
					currentState = MakeMove(currentState, chosenColumn);
				}
				else 
				{
					currentState = MakeMove(currentState);	
				}
			}
			else
			{
				currentState = MakeMove(currentState);
			}
		}
		while(currentState.isFinalState() == false);

		std::cout << "Koniec gry.\n" << currentState << "\n";
		if(currentState.turn != player1)
			std::cout << "ZWYCIĘSTWO!\n";
		else
			std::cout << "PORAŻKA!\n";

		std::cout << "Nowa gra (y/n)";
		char newGame;
		std::cin >> newGame;
		if(newGame == 'n') break;
	}
	return 0;
}
