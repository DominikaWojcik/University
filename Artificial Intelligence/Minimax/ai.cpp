#include "state.h"
#include "ai.h"

const int A_WIN = 1e9;
const int B_WIN = -1e9;
const int SEARCH_DEPTH = 7;

const int TWO = 2;
const int THREE = 10;

int evaluate(GameState& state)
{
	if(state.isFinalState())
	{
		if(state.IsDraw())
			return 0;
		else
		{
			if(state.turn == GameState::A)
				return B_WIN;
			else return A_WIN;
		}
	}

	int pointsA = 0, pointsB = 0;
	
	//kolumnami
	for(int i=0;i<GameState::WIDTH;i++)
	{
		int last = GameState::FREE, count = 0;

		for(int j=0;j<GameState::HEIGHT;j++)
		{
			if(state.board[j][i] != last)
			{
				last = state.board[j][i];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	//wierszami
	for(int i=0;i<GameState::HEIGHT;i++)
	{
		int last = GameState::FREE, count = 0;

		for(int j=0;j<GameState::WIDTH;j++)
		{
			if(state.board[i][j] != last)
			{
				last = state.board[i][j];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	//po skosie w prawo
	for(int k=0;k<GameState::HEIGHT;k++)
	{
		int last = GameState::FREE, count = 0;
		for(int i=k, j=0; i<GameState::HEIGHT && j<GameState::WIDTH; i++,j++)
		{
			if(state.board[i][j] != last)
			{
				last = state.board[i][j];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	for(int k=0;k<GameState::WIDTH;k++)
	{
		int last = GameState::FREE, count = 0;
		for(int i=0, j=k; i<GameState::HEIGHT && j<GameState::WIDTH; i++,j++)
		{
			if(state.board[i][j] != last)
			{
				last = state.board[i][j];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	//po skosie w lewo

	for(int k=0;k<GameState::HEIGHT;k++)
	{
		int last = GameState::FREE, count = 0;
		for(int i=k, j=0; i>=0 && j<GameState::WIDTH; i--,j++)
		{
			if(state.board[i][j] != last)
			{
				last = state.board[i][j];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	for(int k=0;k<GameState::WIDTH;k++)
	{
		int last = GameState::FREE, count = 0;
		for(int i=GameState::HEIGHT-1, j=k; i>=0 && j<GameState::WIDTH; i--,j++)
		{
			if(state.board[i][j] != last)
			{
				last = state.board[i][j];
				count = 0;
			}
			count++;

			if(count >= 2 && last != GameState::FREE)
			{
				if(count == 3)
				{
					if(last == GameState::A) pointsA += THREE;
					else pointsB += THREE;
				}
				if(last == GameState::A) pointsA += TWO;
				else pointsB += TWO;
			}
		}
	}

	return pointsA - pointsB;	
}

std::pair<int,int> Minimax(GameState& state, int dist, int maxi, int mini)
{
	//std::cout << "Minimax dist = "<<dist<<" maxi = "<<maxi<<" mini = "<<mini<<"\n";
	if(dist == 0 || state.isFinalState())
	{
		return std::make_pair(evaluate(state), -1);
	}

	if(state.turn == GameState::A)
	{
		int curMin = mini;
		int childId = 0;
		std::vector<GameState> children = GenerateChildren(state);

		for(int i=0;i<children.size();i++)
		{
			std::pair<int,int> ret = Minimax(children[i], dist-1, maxi, curMin);
			if(ret.second == -2) continue;

			if(curMin < ret.first)
			{
				curMin = ret.first;
				childId = i;
			}
			/*else if(curMin == ret.first)
			{
				childId = (rand() % 2 ? childId : i);
			}*/

			if(curMin > maxi) return std::make_pair(maxi, -2);
		}
		return std::make_pair(curMin, childId);
	}
	else
	{
		int curMax = maxi;
		int childId = 0;
		std::vector<GameState> children = GenerateChildren(state);

		for(int i=0;i<children.size();i++)
		{
			std::pair<int,int> ret = Minimax(children[i], dist-1, curMax, mini);
			if(ret.second == -2) continue;

			if(curMax > ret.first)
			{
				curMax = ret.first;
				childId = i;
			}
			/*else if(curMax == ret.first)
			{
				childId = (rand() % 2 ? childId : i);
			}*/

			if(curMax < mini) return std::make_pair(mini, -2);
		}
		return std::make_pair(curMax, childId);
	}
}


GameState MakeMove(GameState& state, int column)
{
	GameState newState = state;
	column--;

	int j;
	for(j=GameState::HEIGHT-1;j>=0 && state.board[j][column] == GameState::FREE;j--);
	j++;

	newState.board[j][column] = state.turn;
	newState.turn = (state.turn == GameState::A ? GameState::B : GameState::A);
	return newState;
}

GameState MakeMove(GameState& state)
{
	std::pair<int,int> ret = Minimax(state, SEARCH_DEPTH, A_WIN+1, B_WIN-1);
	std::cout<<"Wybrany ruch miał wartość "<<ret.first<<"\n";
	int childId = ret.second;
	return GenerateChildren(state)[childId];
}

GameState MakeMove2(GameState& state)
{
	std::vector<GameState> children = GenerateChildren(state);
	std::vector<int> bestChildren;
	int result;
	if(state.turn == GameState::A)
	{
		result = B_WIN-1;
		for(int i=0; i<children.size(); i++)
		{
			GameState& child = children[i];
			auto ret = Minimax(child, SEARCH_DEPTH-1, A_WIN+1, B_WIN-1);
			if(ret.first > result)
			{
				result = ret.first;
				bestChildren.clear();
				bestChildren.push_back(i);
			}
			else if(ret.first == result)
			{
				bestChildren.push_back(i);
			}
		}
	}
	else
	{
		result = A_WIN+1;
		for(int i=0; i<children.size(); i++)
		{
			GameState& child = children[i];
			auto ret = Minimax(child, SEARCH_DEPTH-1, A_WIN+1, B_WIN-1);
			if(ret.first < result)
			{
				result = ret.first;
				bestChildren.clear();
				bestChildren.push_back(i);
			}
			else if(ret.first == result)
			{
				bestChildren.push_back(i);
			}
		}
	}

	std::cout<<"Możliwe wybory to ";
	for(int i=0;i<bestChildren.size();i++)
	{
		std::cout<<bestChildren[i]+1<<" ";
	}
	std::cout<<"z wartością heurystyki "<<result<<"\n";

	int chosenChild = bestChildren[rand() % bestChildren.size()];
	std::cout<<"Wybieramy numer "<<chosenChild+1<<"\n";
	return children[chosenChild];
}

bool IsValidMove(GameState& state, int column)
{
	column--;
	if(column >= GameState::WIDTH) return false;
	return state.board[GameState::HEIGHT-1][column] == GameState::FREE;
}
