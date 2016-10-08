#include<cstdio>
#include<algorithm>
#define DEBUG 0
#define debug(...) if(DEBUG) printf(__VA_ARGS__)

using namespace std;
typedef long long int ll;
const int maxk=1e5+7;
const int shift = 1<<18;
ll tab[maxk];
ll tree[shift<<1];
int k;
ll l,r;


void add(int pos, ll x)
{
	pos += shift;
	while(pos>0)
	{
		tree[pos] ^= x;
		pos >>= 1;
	}
}

ll query(int a, int b)
{
	ll result = 0ll;
	a+= shift;
	b+= shift;
	if(b < a) return 0ll;
	if(a==b) return tree[a];
	result = tree[a] ^ tree[b];

	int aa = a/2, bb = b/2;
	while(aa != bb)
	{
		if(a == aa*2) result ^= tree[a+1];
		if(b == bb*2 + 1) result ^= tree[b-1];
		a = aa;
		b = bb;
		aa /=2;
		bb/=2;
	}

	return result;
}

int main()
{
	scanf("%d",&k);
	for(int i=1;i<=k;i++)
	{
		scanf("%lld",&tab[i]);
		add(i, tab[i]);
	}

	int q;
	scanf("%d",&q);
	for(int i=0;i<q;i++)
	{
		scanf("%lld%lld",&l,&r);
		ll len = (r - l + 1)%(k+1);
		/*if(l % (k+1) == 0ll){
			l = 1;
			r = k+1 - len;	
		}
		else
		{
			l %= k+1;
			r = l + len - 1;

			if(r > k)
			{
				r = r - len;
				l = l - (k+1 - len);
			}
		}*/
		l -= (l/(k+1) - (l%(k+1) == 0 ? 1 : 0))*(k+1);
		r = l + len - 1;
		if(r > k)
		{
			r = r - len;
			l = l - (k+1 - len);
		}

		debug("%lld %lld\n", l, r);
		printf("%lld\n", query(l,r));
	}
	return 0;
}
