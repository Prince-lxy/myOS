#include "const.h"
#include "type.h"
#include "protect.h"
#include "process.h"

/* GDT */
EXTERN t_8		gdt_ptr[6];		// 0-15:limit	16-47:base
EXTERN DESCRIPTOR	gdt[GDT_SIZE];

/* IDT */
EXTERN t_8		idt_ptr[6];		// 0-15:limit	16-47:base
EXTERN GATE		idt[IDT_SIZE];

/* 任务表 任务状态表 任务堆栈表 */
EXTERN PROCESS		process_table[NUM_TASKS];
EXTERN TSS		tss[NUM_TASKS];
EXTERN t_8		task_stack[NUM_TASKS][STACK_SIZE_TOTAL];
