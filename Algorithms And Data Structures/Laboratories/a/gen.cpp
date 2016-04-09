#include<cstdio>
#include<algorithm>
#include<ctime>
#include<set>
using namespace std;

const int S = 1;
const int M = 10;
const int L = 100;
const int XL = 1000;
const int XXL = 1e5;
const int XXXL = 1e6;

const int SD = 1;
const int MD = 10;
const int LD = 1000;
const int XLD = 100000;
const int XXLD = 1e7;
const int XXXLD = 1e9;

int makeRandom(int a,int b)
{
	return rand()%(b-a+1)+a;
}

set<int> vis;

void generateInput(int size)
{
	int a,b,mind,maxd;
	switch(size)
	{
		case 1:
			a = S;
			b = M;
			mind = SD;
			maxd = MD;
			break;
		case 2:
			a = M;
			b = L;
			mind = MD;
			maxd = LD;
			break;
		case 3:
			a = L;
			b = XL;
			mind = LD;
			maxd = XLD;
			break;
		case 4:
			a = XL;
			b = XXL;
			mind = XLD;
			maxd = XXLD;
			break;
		default:
			a = XXL;
			b = XXXL;
			mind = XXLD;
			maxd = XXXLD;
			break;
	}
	int n = makeRandom(a,b);
	printf("%d\n",n);

	for(int i=0;i<n;i++)
	{

		int num; 
		do
		{
			num = makeRandom(1,maxd);
		}
		while(vis.find(num) != vis.end());
		printf("%d %d\n", num, makeRandom(mind,maxd));
		vis.insert(num);
	}
}

int main(int argc, char* argv[])
{
	srand(atoi(argv[1]));
	generateInput(makeRandom(1,5));
	return 0;
}
