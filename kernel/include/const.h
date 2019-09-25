#ifndef CONST_H
#define CONST_H

/* 变量类型 */
#define	PUBLIC
#define	PRIVATE		static
#define	EXTERN		extern

/* GDT IDT LDT 描述符个数 */
#define	GDT_SIZE	128
#define	IDT_SIZE	256
#define	LDT_SIZE	2

/* GDT 选择子 */
#define SELECTOR_DUMMY		0x0
#define SELECTOR_KERNEL_RW	0x08
#define SELECTOR_KERNEL_X	0x10
#define SELECTOR_VIDEO		(0x18 + 0x3)
#define SELECTOR_TSS		0x20
#define SELECTOR_LDT		0x28

/* 中断向量 */
#define INT_VECTOR_IRQ0         0x20
#define INT_VECTOR_IRQ8         0x28

/* 进程总个数 */
#define NUM_TASKS		4

/* 进程栈大小 */
#define STACK_SIZE_TOTAL	1024

/* irq 调用函数个数 */
#define NUM_IRQ			16

/* 系统调用 */
#define INT_VECTOR_SYS_CALL	0x90
#define NUM_SYS_CALL		1

/* 8253 时钟 */
#define	TIMER0			0x40
#define	TIMER_MODE		0x43
#define	RATE_GENERATOR		0x34
#define	TIMER_FREQ		(5 * 1193182L)
#define	HZ			1000

/* 键盘 */
#define	KEYBOARD_DATA		0x60

#endif /* CONST_H */
