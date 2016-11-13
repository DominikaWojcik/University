#include<chrono>
#include<vector>
#include<queue>
#include<algorithm>
#include<cmath>
#include<string>
#include<cstdio>
#include<unordered_map>

#define ft first
#define sd second
#define DEBUG 0
#define debug(...) if(DEBUG) {fprintf(stderr, __VA_ARGS__);}

using namespace std;

typedef pair<int,int> pii;
typedef pair<string, pii> action;

const int SIZE_X = 30;
const int SIZE_Y = 20;
const int FREE = -1;
const pii LOST = pii(-1,-1);
const double TIME_BUDGET = 95000; //90ms
const double EXPLORATION_COEFFICIENT = 1.;

const unsigned int POOL_SIZE = 2e5+7;

int TURN = -1;
int PLAYERS, MYID;

inline int makeRandom(int n)
{
	return rand() % n;
}

const unordered_map<string, pii> actions = {{"LEFT",{-1,0}}, {"RIGHT",{1,0}}, {"UP",{0,-1}}, {"DOWN",{0,1}}};

struct GameState
{
	int players;
	int currentPlayer;
	vector<vector<pii> >trails;
	int board[SIZE_X][SIZE_Y];

	GameState() {}

	GameState(int players) : players(players)
	{
		for(int i=0;i<SIZE_X;i++)
			for(int j=0;j<SIZE_Y;j++)
				board[i][j] = FREE;

		trails.resize(4, vector<pii>());

		currentPlayer = MYID;
	}

	void update(int player, pii firstPos, pii newPosition)
	{
		if(firstPos == LOST && trails[player].size())
		{
			for(pii& pos : trails[player])
				board[pos.ft][pos.sd] = FREE;
			trails[player].clear();
		}
		else if(firstPos != LOST && (TURN == 0 || newPosition != trails[player].back()))
		{
			if(TURN == 0 && firstPos != newPosition)
			{
				trails[player].push_back(firstPos);
				board[firstPos.ft][firstPos.sd] = player;			
			}

			trails[player].push_back(newPosition);
			board[newPosition.ft][newPosition.sd] = player;			
		}
	}

	string toString()
	{
		string out = "";
		for(int i=0;i<SIZE_Y;i++)
		{
			for(int j=0;j<SIZE_X;j++)
			{
				out.push_back(board[j][i] == FREE ? '.' : '0' + board[j][i]);
			}
			out.push_back('\n');
		}
		return out;
	}

	int nextPlayer()
	{
		int nextPlayer = (currentPlayer + 1) % PLAYERS;
		while(!isAlive(nextPlayer) && nextPlayer != currentPlayer)
			nextPlayer = (nextPlayer+1) % PLAYERS;
		return nextPlayer;
	}

	int prevPlayer()
	{
		int prevPlayer = (currentPlayer - 1 + PLAYERS) % PLAYERS;
		while(!isAlive(prevPlayer) && prevPlayer != currentPlayer)
			prevPlayer = (prevPlayer - 1 + PLAYERS) % PLAYERS;
		return prevPlayer;
	}

	void applyAction(action a)
	{
		auto currentField = trails[currentPlayer].back();
		pii move = a.sd;
		pii	nextField = {currentField.ft + move.ft, currentField.sd + move.sd};
		if(nextField.ft >= 0 && nextField.ft < SIZE_X && nextField.sd >= 0 && nextField.sd < SIZE_Y
				&& board[nextField.ft][nextField.sd] == FREE)
		{
			board[nextField.ft][nextField.sd] = currentPlayer;
			trails[currentPlayer].push_back(nextField);
			currentPlayer = nextPlayer();
		}
		else
		{
			for(pii pos : trails[currentPlayer])
				board[pos.ft][pos.sd] = FREE;
			trails[currentPlayer].clear();
			currentPlayer = nextPlayer();
		}
	}

	vector<action> getPossibleActions()
	{
		vector<action> possible;

		for(action a : actions)
		{
			pii currentField = trails[currentPlayer].back();
			pii move = a.sd;
		    pii	nextField = pii(currentField.ft + move.ft, currentField.sd + move.sd);
			if(nextField.ft >= 0 && nextField.ft < SIZE_X && nextField.sd >= 0 && nextField.sd < SIZE_Y
					&& board[nextField.ft][nextField.sd] == FREE)
			possible.push_back(a);
		}

		//Jesli nic nie mozemy zrobic, to popelniamy samobojstwo idac gdziekolwiek
		if(possible.empty())
		{
			possible.push_back(*actions.begin());
		}

		return possible;
	}

	bool currentPlayerTookAction()
	{
		return trails[currentPlayer].size() >= 2;
	}

	action getPreviousCurrentPlayerAction()
	{
		pii currentPos = trails[currentPlayer].back();
		pii prevPos = trails[currentPlayer][trails[currentPlayer].size()-2];
		pii delta = pii(currentPos.ft - prevPos.ft, currentPos.sd - prevPos.sd);

		for(auto a : actions)
			if(a.sd == delta)
				return a;
	}

	bool isTerminal()
	{
		int activePlayers = 0;
		for(const auto& trail : trails)
			activePlayers += !trail.empty();

		return activePlayers == 1;
	}

	bool isAlive(int player)
	{
		return trails[player].size();
	}
};

GameState currentState;

template<typename TimeT = std::chrono::microseconds, 
    typename ClockT=std::chrono::high_resolution_clock,
    typename DurationT=double>
struct Stopwatch
{
private:
    std::chrono::time_point<ClockT> _start, _end;
public:
    Stopwatch() { start(); }
    void start() { _start = _end = ClockT::now(); }
    DurationT stop() { _end = ClockT::now(); return elapsed();}
    DurationT elapsed() { 
        auto delta = std::chrono::duration_cast<TimeT>(_end-_start);
        return delta.count(); 
    }
};


struct MCTNode
{
	GameState state;
	bool terminal;
	int player;
	
	MCTNode* parent;
	int childId;

	int timesPlayed;

	vector<MCTNode*> children;
	vector<action> possibleActions;
	vector<int> timesChildPlayed;
	vector<int> timesChildWon;

	void initialize(int _player, GameState _state)
	{
		state = _state;
		player = _player;
		terminal = state.isTerminal();

		parent = nullptr;

		timesPlayed = 0;

		initializeChildren();
	}

	void initialize(int _player, GameState _state, action actionTaken, MCTNode* _parent, int _childId)
	{
		state = _state;
		int nextPlayer = state.nextPlayer();
		player = nextPlayer;
		state.applyAction(actionTaken);
		terminal = state.isTerminal();

		parent = _parent;
		childId = _childId;

		timesPlayed = 0;

		initializeChildren();
	}

	bool isFullyExpanded()
	{
		return timesPlayed >= children.size();
	}
	
	int getBestChild()
	{
		int bestChild = 0;
		double maxUCT = 0;
		for(int i=0; i<children.size();i++)
		{
			double UCT = ((double)timesChildWon[i])/timesChildPlayed[i] + 
				EXPLORATION_COEFFICIENT * sqrt(2.* log(timesPlayed) / timesChildPlayed[i]);
			if(UCT > maxUCT)
			{
				maxUCT = UCT;
				bestChild = i;
			}
		}

		return bestChild;	
	}

	action getBestAction()
	{
		return possibleActions[getBestChild()];
	}


private:

	void initializeChildren()
	{
		children.clear();
		timesChildPlayed.clear();
		timesChildWon.clear();

		possibleActions = state.getPossibleActions();
		children.resize(possibleActions.size(), nullptr);
		timesChildPlayed.resize(possibleActions.size(), 0);
		timesChildWon.resize(possibleActions.size(), 0);
	}
};

template<typename T>
struct Pool
{
	T pool[POOL_SIZE];
	unsigned int counter = 0;

	void reset()
	{
		counter = 0;
	}

	T& getNext()
	{
		return pool[counter++];
	}
};

Pool<MCTNode> nodePool;

MCTNode& expand(MCTNode* node)
{
	for(int i=0; i < node->possibleActions.size(); i++)
	{
		if(node->children[i] == nullptr)
		{
			node->children[i] = &nodePool.getNext();
			node->children[i]->initialize(node->player, 
										node->state, 
										node->possibleActions[i], 
										node, 
										i);
			return *(node->children[i]);
			break;
		}
	}

	throw runtime_error("Could not expand node");
}

MCTNode& treePolicy(MCTNode& node)
{
	MCTNode* currentNode = &node;

	while(!currentNode->terminal)
	{
		if(!currentNode->isFullyExpanded())
			return expand(currentNode);
		else
			currentNode = currentNode->children[currentNode->getBestChild()];
	}

	return *currentNode;
}

int defaultPolicy(MCTNode& node)
{
	GameState state = node.state;
	//debug("State to rollout: turn -> %d\n%s\n", state.currentPlayer, state.toString().c_str());

	while(!state.isTerminal())
	{
		auto possibleActions = state.getPossibleActions();
		if(state.currentPlayerTookAction())
		{
			action prevAction = state.getPreviousCurrentPlayerAction();
			if(find(possibleActions.begin(), possibleActions.end(), prevAction) != possibleActions.end())
			{
				state.applyAction(prevAction);
				continue;
			}
		}

		//If we couldn't use previous action. We don't enter this section if we could use previous action
		action randomAction = possibleActions[makeRandom(possibleActions.size())];
		state.applyAction(randomAction);	
	}
	
	return state.currentPlayer;
}

void backup(MCTNode& node, int whoWon)
{
	int childId = node.childId;
	MCTNode* currentNode = node.parent;

	while(currentNode != nullptr)
	{
		currentNode->timesPlayed++;
		currentNode->timesChildPlayed[childId]++;
		if(currentNode->player == whoWon)
			currentNode->timesChildWon[childId]++;

		childId = currentNode->childId;
		currentNode = currentNode->parent;
	}
}

action MCTS(Stopwatch<>& sw)
{
	action strategy = {"LEFT",{-1,0}};
	double maxTime = 0;

	nodePool.reset();
	MCTNode& root = nodePool.getNext();
	root.initialize(MYID, currentState);

	int cnt = 0;
	do
	{
		Stopwatch<> iterSW;

		if(cnt%100 == 0)debug("%d\n", cnt);
		cnt++;
		MCTNode& chosenNode = treePolicy(root);	
		int whoWon = defaultPolicy(chosenNode);
		backup(chosenNode, whoWon);

		maxTime = max(maxTime, iterSW.stop());
		//debug("Max time in microseconds is %lf, elapsed %lf\n", maxTime, sw.stop());
		//debug("Time left is %lf\n", TIME_BUDGET - sw.stop());
			
	} while (maxTime < TIME_BUDGET - sw.stop());

	strategy = root.getBestAction();

	return strategy;
}

vector<int> computeVoronoi(GameState state, action actionToTake)
{
	state.applyAction(actionToTake);

	vector<int>voronoiSizes(state.players, 0);
	queue<pair<pii, int> >Q;

	for(int player = state.currentPlayer, i = 0; i<PLAYERS; player = (player + 1)%PLAYERS, i++)
		if(state.isAlive(player))
			Q.push(make_pair(state.trails[player].back(), player));

	while(!Q.empty())
	{
		auto fieldPlayer = Q.front();
		Q.pop();
		pii field = fieldPlayer.ft;
		int player = fieldPlayer.sd;
		
		voronoiSizes[player]++;
		for(action a : actions)
		{
			pii neighbour = pii(field.ft + a.sd.ft, field.sd + a.sd.sd);
			if(neighbour.ft >= 0 && neighbour.ft < SIZE_X && neighbour.sd >= 0 && neighbour.sd < SIZE_Y &&
					state.board[neighbour.ft][neighbour.sd] == FREE)
			{
				state.board[neighbour.ft][neighbour.sd] = player;
				Q.push(make_pair(neighbour, player));
			}
		}
	}

	return voronoiSizes;
}

action voronoiStrategy(Stopwatch<>& sw)
{
	action strategy = {"LEFT",{-1,0}};

	int maxSize = -1;

	for(action a : currentState.getPossibleActions())
	{
		vector<int> voronoiSizes = computeVoronoi(currentState, a);
		debug("Action %s - %d\n", a.ft.c_str(), voronoiSizes[currentState.currentPlayer]);
		if(voronoiSizes[currentState.currentPlayer] > maxSize)
		{
			maxSize = voronoiSizes[currentState.currentPlayer];
			strategy = a;
		}
	}

	return strategy;
}

action computeStrategy(Stopwatch<>& sw)
{
	return voronoiStrategy(sw);	
//	return MCTS(sw);
}

int main()
{
    while (1) 
	{
		TURN++;
		scanf("%d%d",&PLAYERS, &MYID);
		//uruchom mierzenie czasu
		Stopwatch<> sw;

		if(TURN == 0)
		{
			currentState = GameState(PLAYERS);
		}
		debug("Turn %d\n", TURN);
		debug("Players = %d, my id = %d\n", PLAYERS, MYID);
	
		for (int i = 0; i < PLAYERS; i++) 
		{
			int X0; // starting X coordinate of lightcycle (or -1)
			int Y0; // starting Y coordinate of lightcycle (or -1)
			int X1; // starting X coordinate of lightcycle (can be the same as X0 if you play before this player)
			int Y1; // starting Y coordinate of lightcycle (can be the same as Y0 if you play before this player)
			scanf("%d%d%d%d",&X0, &Y0, &X1, &Y1);
			currentState.update(i, pii(X0,Y0), pii(X1,Y1));
			debug("Player %d - (%d, %d) - (%d, %d)\n", i, X0, Y0, X1, Y1);
		}
		//debug("%s\n", currentState.toString().c_str());
		string order = computeStrategy(sw).ft;
		printf("%s\n", order.c_str());

    }
	return 0;
}
