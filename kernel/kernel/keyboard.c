#include "const.h"
#include "type.h"
#include "protect.h"
#include "string.h"
#include "ports.h"
#include "keyboard.h"

PRIVATE KB_INPUT	kb_in;
PRIVATE int 		keyboard_mode;	// 0:normal 1:shift 2:ctrl

PRIVATE char		keymap[][KEYBOARD_MODE] = {
	/* normal */	/* shift */	/* ctrl */
	0,		0,		0,	/* 0x00 */
	1,		1,		0,	/* 0x01 Esc */
	'1',		'!',		0,	/* 0x02 */
	'2',		'@',		0,	/* 0x03 */
	'3',		'#',		0,	/* 0x04 */
	'4',		'$',		0,	/* 0x05 */
	'5',		'%',		0,	/* 0x06 */
	'6',		'^',		0,	/* 0x07 */
	'7',		'&',		0,	/* 0x08 */
	'8',		'*',		0,	/* 0x09 */
	'9',		'(',		0,	/* 0x0a */
	'0',		')',		0,	/* 0x0b */
	'-',		'_',		0,	/* 0x0c */
	'=',		'+',		0,	/* 0x0d */
	0,		0,		0,	/* 0x0e Backspace */
	0,		0,		0,	/* 0x0f Tab */
	/* normal */	/* shift */	/* ctrl */
	'q',		'Q',		0,	/* 0x10 */
	'w',		'W',		0,	/* 0x11 */
	'e',		'E',		0,	/* 0x12 */
	'r',		'R',		0,	/* 0x13 */
	't',		'T',		0,	/* 0x14 */
	'y',		'Y',		0,	/* 0x15 */
	'u',		'U',		0,	/* 0x16 */
	'i',		'I',		0,	/* 0x17 */
	'o',		'O',		0,	/* 0x18 */
	'p',		'P',		0,	/* 0x19 */
	'[',		'{',		0,	/* 0x1a */
	']',		'}',		0,	/* 0x1b */
	'\n',		'\n',		0,	/* 0x1c Enter */
	0,		0,		0,	/* 0x1d Ctrl */
	'a',		'A',		0,	/* 0x1e */
	's',		'S',		0,	/* 0x1f */
	/* normal */	/* shift */	/* ctrl */
	'd',		'D',		0,	/* 0x20 */
	'f',		'F',		0,	/* 0x21 */
	'g',		'G',		0,	/* 0x22 */
	'h',		'H',		0,	/* 0x23 */
	'j',		'J',		0,	/* 0x24 */
	'k',		'K',		0,	/* 0x25 */
	'l',		'L',		0,	/* 0x26 */
	';',		':',		0,	/* 0x27 */
	'\'',		'\"',		0,	/* 0x28 */
	'`',		'~',		0,	/* 0x29 */
	0,		0,		0,	/* 0x2a Lshift*/
	'\\',		'|',		0,	/* 0x2b */
	'z',		'Z',		0,	/* 0x2c */
	'x',		'X',		0,	/* 0x2d */
	'c',		'C',		0,	/* 0x2e */
	'v',		'V',		0,	/* 0x2f */
	/* normal */	/* shift */	/* ctrl */
	'b',		'B',		0,	/* 0x30 */
	'n',		'N',		0,	/* 0x31 */
	'm',		'M',		0,	/* 0x32 */
	',',		'<',		0,	/* 0x33 */
	'.',		'>',		0,	/* 0x34 */
	'/',		'?',		0,	/* 0x35 */
	0,		0,		0,	/* 0x36 Rshift */
	'*',		'*',		0,	/* 0x37 */
	0,		0,		0,	/* 0x38 Alt */
	' ',		' ',		0,	/* 0x39 space */
	0,		0,		0,	/* 0x3a Caps Lock*/
	0,		0,		0,	/* 0x3b F1 */
	0,		0,		0,	/* 0x3c F2 */
	0,		0,		0,	/* 0x3d F3 */
	0,		0,		0,	/* 0x3e F4 */
	0,		0,		0,	/* 0x3f F5*/
	/* normal */	/* shift */	/* ctrl */
	0,		0,		0,	/* 0x40 F6 */
	0,		0,		0,	/* 0x41 F7 */
	0,		0,		0,	/* 0x42 F8 */
	0,		0,		0,	/* 0x43 F9 */
	0,		0,		0,	/* 0x44 F10 */
	0,		0,		0,	/* 0x45 NumLock */
	0,		0,		0,	/* 0x46 */
	0,		0,		0,	/* 0x47 Home */
	0,		0,		0,	/* 0x48 Up */
	0,		0,		0,	/* 0x49 PgUp */
	0,		0,		0,	/* 0x4a */
	0,		0,		0,	/* 0x4b Left */
	0,		0,		0,	/* 0x4c */
	0,		0,		0,	/* 0x4d Right */
	0,		0,		0,	/* 0x4e */
	0,		0,		0,	/* 0x4f End */
	/* normal */	/* shift */	/* ctrl */
	0,		0,		0,	/* 0x50 Down */
	0,		0,		0,	/* 0x51 PgDn */
	0,		0,		0,	/* 0x52 Insert */
	0,		0,		0,	/* 0x53 Delete */
	0,		0,		0,	/* 0x54 */
	0,		0,		0,	/* 0x55 */
	0,		0,		0,	/* 0x56 */
	0,		0,		0,	/* 0x57 F11 */
	0,		0,		0,	/* 0x58 F12 */
	0,		0,		0,	/* 0x59 */
	0,		0,		0,	/* 0x5a */
	0,		0,		0,	/* 0x5b Windows */
	0,		0,		0,	/* 0x5c */
	0,		0,		0,	/* 0x5d Rclick*/
	0,		0,		0,	/* 0x5e */
	0,		0,		0,	/* 0x5f */
};

PUBLIC void keyboard_read()
{
	t_8 scan_code;
	char output[2];
	t_8 make;				// 1:make 0:break

	output[0] = output[1] = 0;

	if (kb_in.count > 0) {
		scan_code = *(kb_in.tail);
		kb_in.tail++;
		if (kb_in.tail == kb_in.buf + KB_IN_BUF_LEN) {
			kb_in.tail = kb_in.buf;
		}
		kb_in.count--;

		/* 解析扫描码 */
		if (scan_code == 0xe0) {
			/* ... */
		} else {
			/* 打印字符 */
			if (scan_code & 0x80) {
				make = 0;
			} else {
				make = 1;
			}

			/* 大写模式 */
			if (scan_code == 0x3a) {
				if (keyboard_mode == 0) {
					keyboard_mode = 1;
				} else {
					keyboard_mode = 0;
				}
			}

			if (make) {
				output[0] = keymap[scan_code & 0x7f][keyboard_mode];
				k_print_str(output);
#ifdef CONFIG_DEBUG
				k_print_str("(");
				k_print_hex(scan_code);
				k_print_str(")");
				k_print_str(" ");
#endif
			}
		}
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
	keyboard_mode = 0;

	set_irq_handler(KEYBOARD_IRQ, keyboard_handler);
}
