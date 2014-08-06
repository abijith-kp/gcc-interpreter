#include <stdio.h>
void main()
{
#define A 1
#if A >= 2
int a = 2;
#else
int a = 1;
#endif
printf("\n%d\n", a);
#define A 5
}
