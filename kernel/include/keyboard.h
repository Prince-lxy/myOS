#ifndef KEYBOARD_H
#define KEYBOARD_H

#define	KB_IN_BUF_LEN	32

typedef struct s_kb {
	char*	head;
	char*	tail;
	int	count;
	char	buf[KB_IN_BUF_LEN];
} KB_INPUT;

PUBLIC void keyboard_read();
PUBLIC void init_keyboard();

#endif /* KEYBOARD_H */
