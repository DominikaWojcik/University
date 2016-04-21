#include <vector>
#include "state.h"

/*
static const int GameState::WIDTH = 7;
static const int GameState::HEIGHT = 6;
*/
const int GameState::A = 1;
const int GameState::B = 2;
const int GameState::FREE = 0;


GameState::GameState()
{
	for(int i=0;i<HEIGHT;i++)
		for(int j=0;j<WIDTH;j++)
			board[i][j] = FREE;
	turn = A;
}

bool GameState::IsDraw()
{
	bool draw = true;
	for(int i=0;i<WIDTH && draw;i++)
	{
		draw &= (board[HEIGHT-1][i] != FREE);
	}
	return draw;
}

bool GameState::isFinalState()
{
	//Czy nie jest remis?
	if(IsDraw())
	{
		return true;
	}

	//kolumnami
	for(int i=0;i<WIDTH;i++)
	{
		int last = FREE, count = 0;

		for(int j=0;j<HEIGHT;j++)
		{
			if(board[j][i] != last)
			{
				last = board[j][i];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	//wierszami
	for(int i=0;i<HEIGHT;i++)
	{
		int last = FREE, count = 0;

		for(int j=0;j<WIDTH;j++)
		{
			if(board[i][j] != last)
			{
				last = board[i][j];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	//po skosie w prawo
	for(int k=0;k<HEIGHT;k++)
	{
		int last = FREE, count = 0;
		for(int i=k, j=0; i<HEIGHT && j<WIDTH; i++,j++)
		{
			if(board[i][j] != last)
			{
				last = board[i][j];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	for(int k=0;k<WIDTH;k++)
	{
		int last = FREE, count = 0;
		for(int i=0, j=k; i<HEIGHT && j<WIDTH; i++,j++)
		{
			if(board[i][j] != last)
			{
				last = board[i][j];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	//po skosie w lewo

	for(int k=0;k<HEIGHT;k++)
	{
		int last = FREE, count = 0;
		for(int i=k, j=0; i>=0 && j<WIDTH; i--,j++)
		{
			if(board[i][j] != last)
			{
				last = board[i][j];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	for(int k=0;k<WIDTH;k++)
	{
		int last = FREE, count = 0;
		for(int i=HEIGHT-1, j=k; i>=0 && j<WIDTH; i--,j++)
		{
			if(board[i][j] != last)
			{
				last = board[i][j];
				count = 0;
			}
			count++;

			if(count >= WIN_CONDITION && last != FREE)
			{
				return true;
			}
		}
	}

	return false;
}


std::vector<GameState> GenerateChildren(GameState& state)
{
	std::vector<GameState> children;
	for(int i=0;i<GameState::WIDTH;i++)
	{
		int j;
		for(j=GameState::HEIGHT-1;j>=0 && state.board[j][i] == GameState::FREE;j--);
		j++;
		if(j == GameState::HEIGHT) continue;
		GameState newState = state;
		newState.board[j][i] = state.turn;
		newState.turn = (state.turn == GameState::A ? GameState::B : GameState::A);
		children.push_back(newState);
	}
	
	return children;
}

std::ostream& operator << (std::ostream& out, const GameState& state)
{
	out << "|1|2|3|4|5|6|7|\n";
	for(int i=GameState::HEIGHT-1;i>=0;i--)
	{
		for(int j=0;j<GameState::WIDTH;j++)
		{
			out << "|";
			switch(state.board[i][j])
			{
				case GameState::A: 
					out << "\033[1;32mA\033[0m";
					break;
				case GameState::B:
					out << "\033[1;31mB\033[0m";
					break;
				default:
					out << " ";
					break;
			}
		}
		out << "|";
		if(i>0) out << "\n";
	}

	return out;
}
