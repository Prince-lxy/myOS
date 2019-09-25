#include "const.h"
#include "type.h"
#include "keyboard.h"

PUBLIC void task_tty()
{
	while (1) {
		keyboard_read();
	}
}
