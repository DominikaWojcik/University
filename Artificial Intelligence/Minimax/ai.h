#include<iostream>
#include <algorithm>

#ifndef __AI_H__
#define __AI_H__


std::pair<int,int> Minimax(GameState& state, int dist, int maxi, int mini);

bool IsValidMove(GameState& state, int column);

GameState MakeMove(GameState& state, int column);

GameState MakeMove(GameState& state);
GameState MakeMove2(GameState& state);

int evaluate(GameState& state);

#endif // __AI_H__
