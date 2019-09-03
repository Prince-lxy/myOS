#include "string.h"
#include "global.h"

PUBLIC PROCESS		process_table[NUM_TASKS];
PUBLIC TSS		tss;
PUBLIC t_8		task_stack[NUM_TASKS][STACK_SIZE_TOTAL];

PUBLIC PROCESS*		p_process_table = &process_table[0];

PUBLIC void delay(int time)
{
	int i, j, k;
	for (i = 0; i < time; i++) {
		for (j  = 0; j < 5000; j++) {
			for (k = 0; k < 5000; k++) {}
		}
	}
}

void process_C()
{
	int i = 0;
	k_print_str("process_C:");
	while(1){
		k_print_str("C");
		k_print_hex(i++);
		k_print_str(" ");
		delay(1);
	}
}

void process_B()
{
	int i = 0;
	k_print_str("process_B:");
	while(1){
		k_print_str("B");
		k_print_hex(i++);
		k_print_str(" ");
		delay(1);
	}
}

void process_A()
{
	int i = 0;
	k_print_str("process_A:");
	while(1){
		k_print_str("A");
		k_print_hex(i++);
		k_print_str(" ");
		delay(1);
	}
}

PUBLIC void init_process(int pid, void* func)
{
	PROCESS* p_process = &process_table[pid];

	/* regs */
	p_process->regs.ds = (0 & SA_RPL_MASK & SA_TI_MASK) | SA_RPL3 | SA_TIL;
	p_process->regs.es = (0 & SA_RPL_MASK & SA_TI_MASK) | SA_RPL3 | SA_TIL;
	p_process->regs.fs = (0 & SA_RPL_MASK & SA_TI_MASK) | SA_RPL3 | SA_TIL;
	p_process->regs.ss = (0 & SA_RPL_MASK & SA_TI_MASK) | SA_RPL3 | SA_TIL;
	p_process->regs.cs = (8 & SA_RPL_MASK & SA_TI_MASK) | SA_RPL3 | SA_TIL;
	p_process->regs.gs = (SELECTOR_VIDEO & SA_RPL_MASK) | SA_RPL3;
	p_process->regs.eip = (t_32)func;
	p_process->regs.esp = (t_32)task_stack[pid] + STACK_SIZE_TOTAL;
	p_process->regs.eflags = 0x1200;

	/* ldt selector */
	p_process->ldt_selector = SELECTOR_LDT + (0x8 * pid);

	/* ldts[LDT_SIZE] */
	memcpy(&p_process->ldts[0], &gdt[SELECTOR_KERNEL_RW >> 3], sizeof(DESCRIPTOR));
	p_process->ldts[0].attr1 = DA_DRW | DA_DPL3;
	memcpy(&p_process->ldts[1], &gdt[SELECTOR_KERNEL_X >> 3], sizeof(DESCRIPTOR));
	p_process->ldts[1].attr1 = DA_X | DA_DPL3;

	/* pid */
	p_process->pid = pid;

	/* GDT LDT */
	init_descriptor(&gdt[(SELECTOR_LDT + (0x8 * pid)) >> 3], vir2phys(seg2phys(SELECTOR_KERNEL_RW),
			 process_table[0].ldts), LDT_SIZE * sizeof(DESCRIPTOR), DA_LDT);
}

void init_tss()
{
	/* tss */
	memset(&tss, 0, sizeof(TSS));
	tss.ss0 = SELECTOR_KERNEL_RW;

	/* GDT SELECTOR_TSS */
	init_descriptor(&gdt[SELECTOR_TSS >> 3], vir2phys(seg2phys(SELECTOR_KERNEL_RW), &tss),
			sizeof(TSS), DA_386TSS);
}

PUBLIC void main()
{
	init_tss();
	init_process(0, process_A);
	init_process(1, process_B);
	init_process(2, process_C);

	k_print_str("main finished\n");
}
