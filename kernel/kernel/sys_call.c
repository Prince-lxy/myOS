#include "const.h"
#include "type.h"
#include "string.h"
#include "global.h"

PUBLIC t_sys_call	sys_call_table[NUM_SYS_CALL] = {sys_get_ticks};

PUBLIC int sys_get_ticks()
{
	k_print_str("+");
	return 0;
}
