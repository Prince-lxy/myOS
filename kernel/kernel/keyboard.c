#include "const.h"
#include "type.h"
#include "protect.h"
#include "string.h"
#include "ports.h"
#include "keyboard.h"

PRIVATE KB_INPUT	kb_in;

PUBLIC void keyboard_read()
{
	t_8 scan_code;

	if (kb_in.count > 0) {
		scan_code = *(kb_in.tail);
		kb_in.tail++;
		if (kb_in.tail == kb_in.buf + KB_IN_BUF_LEN) {
			kb_in.tail = kb_in.buf;
		}
		kb_in.count--;

		k_print_hex(scan_code);
		k_print_str(" ");
	}
}

PUBLIC void keyboard_handler(int irq)
{
	t_8 scan_code = in_byte(KEYBOARD_DATA);

	if (kb_in.count < KB_IN_BUF_LEN) {
		*(kb_in.head) = scan_code;
		kb_in.head++;
		if (kb_in.head == kb_in.buf + KB_IN_BUF_LEN) {
			kb_in.head = kb_in.buf;
		}
		kb_in.count++;
	}
}

PUBLIC void init_keyboard()
{
	kb_in.count = 0;
	kb_in.head = kb_in.tail = kb_in.buf;

	set_irq_handler(KEYBOARD_IRQ, keyboard_handler);
}
