#include "const.h"
#include "string.h"

PUBLIC char * k_htoa(char * num_str, int num)
{
	char * p = num_str;
	char ch;
	int i;
	int flag = 0;

	*p++ = '0';
	*p++ = 'x';

	if (num == 0) {
		*p++ = '0';
	} else {
		for (i = 28; i >= 0; i -= 4) {
			ch = (num >> i) & 0xf;
			if (flag || (ch > 0)) {
				flag = 1;
				ch += '0';
				if (ch > '9') {
					ch += 7;
				}
				*p++ = ch;
			}
		}
	}
	*p = '\0';
	return num_str;
}

PUBLIC void k_print_hex(int num)
{
	char num_str[16];
	k_htoa(num_str, num);
	k_print_str(num_str);
}
