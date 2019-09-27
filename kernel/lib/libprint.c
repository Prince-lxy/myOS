#include "const.h"
#include "string.h"
#include "global.h"
#include "ports.h"
#include "sys_call.h"

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

PUBLIC void print_str(char *str)
{
	k_print_str(str);
	set_cursor();
}

PUBLIC void print_hex(int num)
{
	k_print_hex(num);
	set_cursor();
}

PUBLIC void clear()
{
	int i;
	k_print_pos = 0;

	for (i = 0; i < 80 * 25 ; i++) {
		k_print_str(" ");
	}

	k_print_pos = 80 * 2;

	/* 设置光标 */
	out_byte(VIDEO_PORT_REG, CURSOR_ADDR_HIGH);
	out_byte(VIDEO_PORT_DATA, 0);
	out_byte(VIDEO_PORT_REG, CURSOR_ADDR_LOW);
	out_byte(VIDEO_PORT_DATA, 80);
}
