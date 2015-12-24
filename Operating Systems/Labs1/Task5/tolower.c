#include <stdio.h>
#define BUF_SIZE 128

int main()
{
	char buffer[BUF_SIZE];
	printf("Tolower zostalo urochomione\n");
	while(scanf("%s", buffer) > 0)
	{
		printf("tolower otrzymal: %s\n", buffer);
		for(int i=0;i<BUF_SIZE && buffer[i]!=0; i++)
		{
			if(buffer[i]>='A' && buffer[i]<='Z')
				buffer[i]= 'a' + (buffer[i] - 'A');
		}
		printf("tolower wypisal: %s\n", buffer);
	}
	
	return 0;
}