#include<cstdio>
#include<algorithm>
#include<vector>
using namespace std;

const int maxn = 1e6+7;
int tab[maxn];
int base[maxn], exponent[maxn];
int cnt[maxn];
int n, result = 0;
vector<int> sorting;
long long int number[70];
int minExp, maxExp;

bool comp(int a, int b)
{
	return base[a]<base[b];
}

void updateResult()
{
	//printf("Jestem w update result\n");
	for(int i=minExp;i<64 && i<=maxExp;i++)
	{
		//if(number[i]) printf("%d ma %d jednostek\n",i, number[i]);
		number[i+1] += number[i]/2ll;
		if(number[i+1] > 0) maxExp = max(maxExp, i+1);		
		if(number[i]&1ll) result++;
		number[i] = 0;
	}
	minExp = 64;
	maxExp = 0;
}

/*
void printDebug()
{
	printf("------------\n");
	for(int i=0;i<n;i++)
	{
		printf("tab = %d, cnt =  %d, base =  %d, exponent = %d\n", 
			tab[i], cnt[i], base[i], exponent[i]);
	}

	printf("-----------\n");
	for(int i=0;i<sorting.size();i++)
	{
		printf("sorting %d = %d\n", i, sorting[i]);
	}
	printf("-----------\n");
}*/

int main()
{
	scanf("%d",&n);
	for(int i=0;i<n;i++)
	{
		scanf("%d%d", &tab[i], &cnt[i]);
		int e = __builtin_ctz(tab[i]);
		base[i] = (tab[i] >> e);
		exponent[i] = e;
		sorting.push_back(i);
	}
	
	//printf("Przed sortem\n");
	sort(sorting.begin(),sorting.end(),comp);

	//printDebug();
	
	int	last = -1;
	for(int i=0;i<sorting.size();i++)
	{
		if(base[sorting[i]] != last)
		{
			updateResult();
		}
		last = base[sorting[i]];
		number[exponent[sorting[i]]] += cnt[sorting[i]];
		minExp = min(minExp, exponent[sorting[i]]);
		maxExp = max(maxExp, exponent[sorting[i]]);
	}
	updateResult();

	printf("%d\n", result);
	return 0;
}
