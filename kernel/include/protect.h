#ifndef PROTECT_H
#define PROTECT_H

#include "const.h"
#include "type.h"

/* 段描述符 */
typedef struct s_descriptor
{
	t_16	limit_low;			// LIMIT
	t_16	base_low;			// BASE
	t_8	base_mid;			// BASE
	t_8	attr1;				// P(1) DPL(2) DT(1) TYPE(4)
	t_8	limit_high_attr2;		// G(1) D(1) 0(1) AVL(1) limithigh(4)
	t_8	base_high;			// BASE
}DESCRIPTOR;

/* 门描述符 */
typedef struct s_gate
{
	t_16	offset_low;			// OFFSET LOW
	t_16	selector;			// SELECTOR
	t_8	dcount;				// 仅调用门可用
	t_8	attr;				// P(1) DPL(2) DT(1) TYPE(4)
	t_16	offset_high;			// OFFSET HIGH
}GATE;

/* TSS */
typedef struct s_tss
{
	t_32	backlink;
	t_32	esp0;
	t_32	ss0;
	t_32	esp1;
	t_32	ss1;
	t_32	esp2;
	t_32	ss2;
	t_32	cr3;
	t_32	eip;
	t_32	eflags;
	t_32	eax;
	t_32	ecx;
	t_32	edx;
	t_32	ebx;
	t_32	esp;
	t_32	ebp;
	t_32	esi;
	t_32	edi;
	t_32	es;
	t_32	cs;
	t_32	ss;
	t_32	ds;
	t_32	fs;
	t_32	gs;
	t_32	ldt;
	t_16	trap;
	t_16	iobase;
}TSS;



/* 段描述符属性 */
#define DA_32			0x4000
#define DA_LIMIT_4K		0x8000

#define	DA_DPL0			0x00		// DPL = 0
#define	DA_DPL1			0x20		// DPL = 1
#define	DA_DPL2			0x40		// DPL = 2
#define	DA_DPL3			0x60		// DPL = 3

#define	DA_DR			0x90		// Read-Only
#define	DA_DRW			0x92		// Read/Write
#define	DA_DRWA			0x93		// Read/Write, accessed
#define	DA_X			0x98		// Execute-Only
#define	DA_XR			0x9A		// Execute/Read
#define	DA_XCO			0x9C		// Execute-Only, conforming
#define	DA_XCOR			0x9E		// Execute/Read-Only, conforming

#define	DA_LDT			0x82		// LDT
#define	DA_TaskGate		0x85		// Task Gate
#define	DA_386TSS		0x89		// 32-bit TSS(Available)
#define	DA_386CGate		0x8C		// 32-bit Call Gate
#define	DA_386IGate		0x8E		// 32-bit Interrupt Gate
#define	DA_386TGate		0x8F		// 32-bit Trap Gate

/* 选择子属性 */
#define SA_RPL_MASK		0xfffc
#define SA_RPL0 		0
#define SA_RPL1 		1
#define SA_RPL2 		2
#define SA_RPL3 		3
#define SA_TI_MASK		0xfffb
#define SA_TIG  		0
#define SA_TIL  		4

/* 8259A 中断向量 */
#define CLOCK_IRQ		0
#define KEYBOARD_IRQ		1
#define SLAVE_IRQ		2
#define SERIAL2_IRQ		3
#define SERIAL1_IRQ		4
#define PARALLEL2_IRQ		5
#define FLOPPY_IRQ		6
#define PARALLEL1_IRQ		7
#define R_CLOCK_IRQ		8
#define INTA_IRQ		9
#define IRQ_10			10
#define IRQ_11			11
#define PS2_IRQ			12
#define COPROCESSOR		13
#define HD_IRQ			14
#define IRQ15			15

/* 中断处理函数 */
void divide_error();
void debug();
void nmi();
void breakpoint_exception();
void overflow();
void bounds_range_exceeded();
void undefined_opcode();
void no_machine();
void double_fault();
void copr_seg_overrun();
void inval_tss();
void segment_not_present();
void stack_exception();
void general_protection();
void page_fault();
void math_fault();
void align_check();
void machine_check();
void float_point_exception();

void hwint00();
void hwint01();
void hwint02();
void hwint03();
void hwint04();
void hwint05();
void hwint06();
void hwint07();
void hwint08();
void hwint09();
void hwint10();
void hwint11();
void hwint12();
void hwint13();
void hwint14();
void hwint15();

PUBLIC int enable_irq(int irq);
PUBLIC int disable_irq(int irq);
PUBLIC void init_idt();
PUBLIC void init_8259a();

PUBLIC void init_idt_desc(t_8 vector_num, t_8 desc_type, t_int_handler handler, t_8 privilege);
PUBLIC void init_descriptor(DESCRIPTOR * p_desc, t_32 base, t_32 limit, t_16 attribute);
PUBLIC t_32 seg2phys(t_16 seg);
#define vir2phys(seg_base, vir) (t_32)(((t_32)(seg_base)) + ((t_32)(vir)))

PUBLIC int get_ticks();
PUBLIC int sys_get_ticks();
PUBLIC void sys_call();

#endif /* PROTECT_H */
