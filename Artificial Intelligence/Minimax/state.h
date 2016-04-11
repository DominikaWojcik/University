#include <vector>
#include <iostream>
#include <algorithm>

#ifndef __STATE_H__
#define __STATE_H__

struct GameState
{
	static const int WIDTH=7, HEIGHT=6, WIN_CONDITION=4;
	static const int A, B, FREE;
	
	int board[HEIGHT][WIDTH];
	int turn;

	GameState();

	bool IsDraw();

	bool isFinalState();
	
	friend std::ostream& operator << (std::ostream& out, const GameState& state);

};

std::vector<GameState> GenerateChildren(GameState& state);

#endif // __STATE_H__
