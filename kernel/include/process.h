#ifndef PROCESS_H
#define PROCESS_H

#include "type.h"
#include "protect.h"

typedef struct s_stackframe {
	t_32	gs;
	t_32	fs;
	t_32	es;
	t_32	ds;
	t_32	edi;
	t_32	esi;
	t_32	ebp;
	t_32	kernel_esp;
	t_32	ebx;
	t_32	edx;
	t_32	ecx;
	t_32	eax;
	t_32	retaddr;
	t_32	eip;
	t_32	cs;
	t_32	eflags;
	t_32	esp;
	t_32	ss;
}STACK_FRAME;

typedef struct s_process {
	STACK_FRAME	regs;			// 寄存器
	t_16		ldt_selector;		// LDT 选择子
	DESCRIPTOR	ldts[LDT_SIZE];		// LDTs
	t_32		pid;			// 进程号
	char		p_name[16];		// 进程名字
}PROCESS;

#endif /* PROCESS_H */
