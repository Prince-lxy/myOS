#include "const.h"

PUBLIC void* memset(void *s, int c, int n)
{
	const unsigned char uc = c;
	unsigned char *su;
	for (su = s; 0 < n; ++su, --n) {
		*su = uc;
	}
	return s;
}
