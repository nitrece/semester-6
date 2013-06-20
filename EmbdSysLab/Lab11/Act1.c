#include <reg51.h>

void main(void)
{
	unsigned char	i;
	char* cstrData = "012345ABCDE";
	
	while(1)
	{
		for(i=0; i<10; i++)
			P1 = cstrData[i];
	}
}