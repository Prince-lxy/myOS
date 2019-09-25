#include "const.h"
#include "type.h"
#include "protect.h"
#include "string.h"
#include "ports.h"
#include "keyboard.h"

PUBLIC void keyboard_handler(int irq)
{
	k_print_hex(in_byte(KEYBOARD_DATA));
	k_print_str(" ");
}

PUBLIC void init_keyboard()
{
	set_irq_handler(KEYBOARD_IRQ, keyboard_handler);
}
