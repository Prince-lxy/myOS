#include "const.h"
#include "type.h"
#include "string.h"
#include "global.h"
#include "ports.h"

PUBLIC t_sys_call	sys_call_table[NUM_SYS_CALL] = {sys_get_ticks, sys_set_cursor};

PUBLIC int sys_get_ticks()
{
	return ticks;
}

PUBLIC void sys_set_cursor()
{
	out_byte(VIDEO_PORT_REG, CURSOR_ADDR_HIGH);
	out_byte(VIDEO_PORT_DATA, (k_print_pos >> 9) & 0xff);
	out_byte(VIDEO_PORT_REG, CURSOR_ADDR_LOW);
	out_byte(VIDEO_PORT_DATA, (k_print_pos >> 1) & 0xff);
}
