#include <cstdio>
#include <algorithm>

int makeRandom(int a, int b)
{
	return rand()%(b-a+1)+a;
}

using namespace std;
int main(int argc, char* argv[])
{
	int seed = atoi(argv[1]);
	srand(seed);

	int w = makeRandom(3,1000);
	int k = makeRandom(3,1000);
	printf("%d %d\n", w, k);
	for(int i=0;i<w;i++)
	{
		for(int j=0;j<k;j++)
		{
			printf("%d", makeRandom(0,9));
		}
		printf("\n");
	}
	return 0;
}
