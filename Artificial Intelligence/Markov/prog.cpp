#include <cmath>
#include <cstdio>
#include <vector>
#include <algorithm>

using namespace std;

typedef pair<int,int> pii;

const int maxSize = 1e2+7;
const int maxIterations = 40;
const double INF = 1e7;

char Board[maxSize][maxSize];
double Reward[maxSize][maxSize];
double Utility[2][maxSize][maxSize];
char Policy[maxSize][maxSize];

int width, height, rewards;
double discount, epsilon, defaultReward;

double P_forward, P_left, P_right, P_backwards;
double P[4]; // forward, left, backwards, right

const int ACTIONS = 4;
// up, left, down, right
pii actions[] = {pii(-1,0), pii(0,-1), pii(1,0), pii(0,1)};
char moves[] = {'^', '<', 'v', '>'};

bool StableSituation(int iter)
{
	if(iter < 2) return false;
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(fabs(Utility[iter%2][i][j] - Utility[(iter-1)%2][i][j]) > epsilon)
			{
				return false;
			}
		}
	}

	return true;
}

void ComputeUtility(int iter)
{
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(Board[i][j] == 'F') continue;
			else if(Board[i][j] == 'T')
			{
				Utility[iter%2][i][j] = Utility[(iter-1)%2][i][j];
				continue;
			}

			Utility[iter%2][i][j] = Reward[i][j];
			double maximumExpUtility = -INF;

			for(int k = 0; k < ACTIONS;k++)
			{
				double utility = 0.0;

				for(int l = 0; l < ACTIONS;l++)
				{
					int ii = i + actions[(k+l)%ACTIONS].first;
					int jj = j + actions[(k+l)%ACTIONS].second;
					
					//Jesli się odbijam
					if(ii < 0 || ii >= height || 
						jj < 0 || jj >= width || 
						Board[ii][jj] == 'F')
					{
						utility += P[l] * Utility[(iter-1)%2][i][j];
					}
					else
					{
						utility += P[l] * Utility[(iter-1)%2][ii][jj];
					}
				}

				maximumExpUtility = max(utility, maximumExpUtility);
			}

			Utility[iter%2][i][j] += maximumExpUtility * discount;
		}
	}
}

void ComputePolicy(int iter)
{
	for(int i=0; i<height; i++)
	{
		for(int j=0; j<width; j++)
		{
			if(Board[i][j] == 'F' || Board[i][j] == 'T') 
			{
				Policy[i][j] = Board[i][j];
				continue;
			}

			double maximumExpUtility = -INF;

			for(int k = 0; k < ACTIONS;k++)
			{
				double utility = 0.0;

				for(int l = 0; l < ACTIONS;l++)
				{
					int ii = i + actions[(k+l)%ACTIONS].first;
					int jj = j + actions[(k+l)%ACTIONS].second;
					
					//Jesli się odbijam
					if(ii < 0 || ii >= height || 
						jj < 0 || jj >= width || 
						Board[ii][jj] == 'F')
					{
						utility += P[l] * Utility[(iter-1)%2][i][j];
					}
					else
					{
						utility += P[l] * Utility[(iter-1)%2][ii][jj];
					}
				}

				if(maximumExpUtility < utility)
				{
					maximumExpUtility = utility;
					Policy[i][j] = moves[k];
				}
			}
		}
	}
}

void PrintUtilities(int iteration)
{
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			if(Board[i][j] != 'F')
			{
				printf("%lf ", Utility[iteration%2][i][j]);
			}
			else printf("F ");
		}
		printf("\n");
	}
}

void PrintPolicy()
{
	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			printf("%c ", Policy[i][j]);
		}
		printf("\n");
	}
}

int main()
{
	scanf("%d %d", &height, &width);

	for(int i=0;i<height;i++)
	{
		scanf("%s", Board[i]);
	}

	scanf("%d %lf", &rewards, &defaultReward);

	for(int i=0;i<height;i++)
	{
		for(int j=0;j<width;j++)
		{
			Reward[i][j] = defaultReward;
		}
	}

	for(int i=0;i<rewards;i++)
	{
		int x,y;
		double r;
		scanf("%d %d %lf", &x, &y, &r);
		Reward[x][y] = r;
		Utility[0][x][y] = r;
	}

	scanf("%lf %lf %lf", &P[0], &P[1], &P[3]);
	P[2] = 1.0 - (P[0] + P[1] + P[3]);

	scanf("%lf %lf", &discount, &epsilon);

	int iteration;
	for(iteration = 1; //iteration < maxIterations && 
		!StableSituation(iteration); iteration++)
	{
		ComputeUtility(iteration);
	}
	iteration--;
	printf("%d ITERACJE\n", iteration);

	ComputePolicy(iteration);

	PrintUtilities(iteration);
	PrintPolicy();

	return 0;
}
