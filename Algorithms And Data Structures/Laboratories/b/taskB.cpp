#include <cstdio>
#include <algorithm>
#include <vector>

using namespace std;
const int maxn = 5e3+9;
long long int dp[3][maxn][2];
char input[maxn];
long long int pot[10];
int w,k;

inline int kol(int nrKol)
{
	return nrKol + 2;
}

int main()
{
	pot[0] = 1ll;
	for(int i=1;i<10;i++) pot[i] = pot[i-1] * 7ll;
	
	scanf("%d%d",&w,&k);
	for(int i=0;i<w;i++)
	{
		scanf("%s", input);
		for(int j=0;j<k;j++)
		{
			dp[i%3][kol(j)][0] = pot[input[j] - '0'];
			dp[i%3][kol(j)][1] = pot[input[j] - '0'];
		}

		for(int j=0;j<k;j++)
		{
			long long int poDrodze = max(max(dp[(i-2+3)%3][kol(j-1)][0],dp[(i-2+3)%3][kol(j-1)][1]), max(dp[(i-2+3)%3][kol(j+1)][0],dp[(i-2+3)%3][kol(j+1)][1]));
			if(poDrodze == 0ll && i>0)
			{
				dp[i%3][kol(j)][0] = 0ll;
			}
			else dp[i%3][kol(j)][0] += poDrodze;
		}

/*
		printf("DP 0 rzad %d\n", i);
		for(int j=0;j<k;j++)
		{
			printf("%lld ", dp[i%3][kol(j)][0]);
		}
		printf("\n");
*/

		for(int j=0;j<k;j++)
		{
			long long int poDrodze = max(dp[i%3][kol(j-2)][0], dp[i%3][kol(j+2)][0]);
			if(poDrodze == 0ll || (i-1)<1) 
				dp[(i-1+3)%3][kol(j)][1] = 0ll;
			else dp[(i-1+3)%3][kol(j)][1] += poDrodze;
		}
/*
		printf("DP 1 rzad %d\n", i-1);
		for(int j=0;j<k;j++)
		{
			printf("%lld ", dp[(i-1+3)%3][kol(j)][1]);
		}
		printf("\n");
*/

	}

	long long int ans = 0;
	for(int j=0;j<k;j++)
	{
		ans = max(ans, dp[(w-1+3)%3][kol(j)][0]);
	}

	printf("%lld\n", ans);

	return 0;
}
