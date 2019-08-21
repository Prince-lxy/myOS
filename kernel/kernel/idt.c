#include "const.h"
#include "type.h"
#include "string.h"
#include "protect.h"
#include "global.h"

PUBLIC char err_description[][64] = {
	"#DE Divide Error",
	"#DB Debug",
	"--- NMI Interrupt",
	"#BP Breakpoint",
	"#OF Overflow",
	"#BR Bound Range Exceeded",
	"#UD Undefined opcode",
	"#NM No machine",
	"#DF Double Fault",
	"--- Coprocessor Segment Overrun (reserved)",
	"#TS Invalid TSS",
	"#NP Segment Not Present",
	"#SS Stack-Segment Fault",
	"#GP General Protection",
	"#PF Page Fault",
	"--- (Intel reserved)",
	"#MF x87 FPU Floating-Point Error (Math Fault)",
	"#AC Alignment Check",
	"#MC Machine Check",
	"#XF SIMD Floating-Point Exception"
};

PUBLIC void irq_handler(int irq)
{
	k_print_str("irq: ");
	k_print_hex(irq);
	k_print_str("\n");
}

PUBLIC void exception_handler(int vec_num, int err_code, int eip, int cs, int eflags)
{
	k_print_str("Exception --> ");
	k_print_str(err_description[vec_num]);
	k_print_str("\n");
	k_print_str("EFLAGS: ");
	k_print_hex(eflags);
	k_print_str(" CS: ");
	k_print_hex(cs);
	k_print_str(" EIP: ");
	k_print_hex(eip);

	if (err_code != 0xffffffff) {
		k_print_str(" Error code: ");
		k_print_hex(err_code);
	}
	k_print_str("\n");
}

PUBLIC void init_idt_desc(t_8 vector_num, t_8 desc_type, t_int_handler handler, t_8 privilege)
{
	GATE * gate		= &idt[vector_num];
	t_32 base		= (t_32) handler;

	gate->offset_low	= base & 0xffff;
	gate->selector		= SELECTOR_KERNEL_X;				// gdt + 0x10
	gate->dcount		= 0;
	gate->attr		= desc_type | (privilege << 5);
	gate->offset_high	= (base >> 16) & 0xffff;
}

PUBLIC void init_idt()
{
	/* X86 保护模式 0x0-0x1f */
	init_idt_desc(0, DA_386IGate, divide_error, PRIVILEGE_KERLEL);
	init_idt_desc(1, DA_386IGate, debug, PRIVILEGE_KERLEL);
	init_idt_desc(2, DA_386IGate, nmi, PRIVILEGE_KERLEL);
	init_idt_desc(3, DA_386IGate, breakpoint_exception, PRIVILEGE_KERLEL);
	init_idt_desc(4, DA_386IGate, overflow, PRIVILEGE_KERLEL);
	init_idt_desc(5, DA_386IGate, bounds_range_exceeded, PRIVILEGE_KERLEL);
	init_idt_desc(6, DA_386IGate, undefined_opcode, PRIVILEGE_KERLEL);
	init_idt_desc(7, DA_386IGate, no_machine, PRIVILEGE_KERLEL);
	init_idt_desc(8, DA_386IGate, double_fault, PRIVILEGE_KERLEL);
	init_idt_desc(9, DA_386IGate, copr_seg_overrun, PRIVILEGE_KERLEL);
	init_idt_desc(10, DA_386IGate, inval_tss, PRIVILEGE_KERLEL);
	init_idt_desc(11, DA_386IGate, segment_not_present, PRIVILEGE_KERLEL);
	init_idt_desc(12, DA_386IGate, stack_exception, PRIVILEGE_KERLEL);
	init_idt_desc(13, DA_386IGate, general_protection, PRIVILEGE_KERLEL);
	init_idt_desc(14, DA_386IGate, page_fault, PRIVILEGE_KERLEL);
	init_idt_desc(16, DA_386IGate, math_fault, PRIVILEGE_KERLEL);
	init_idt_desc(17, DA_386IGate, align_check, PRIVILEGE_KERLEL);
	init_idt_desc(18, DA_386IGate, machine_check, PRIVILEGE_KERLEL);
	init_idt_desc(19, DA_386IGate, float_point_exception, PRIVILEGE_KERLEL);

	/* 8259A 主片 */
	init_idt_desc(INT_VECTOR_IRQ0 + 0, DA_386IGate, hwint00, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 1, DA_386IGate, hwint01, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 2, DA_386IGate, hwint02, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 3, DA_386IGate, hwint03, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 4, DA_386IGate, hwint04, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 5, DA_386IGate, hwint05, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 6, DA_386IGate, hwint06, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ0 + 7, DA_386IGate, hwint07, PRIVILEGE_KERLEL);

	/* 8259A 从片 */
	init_idt_desc(INT_VECTOR_IRQ8 + 0, DA_386IGate, hwint08, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 1, DA_386IGate, hwint09, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 2, DA_386IGate, hwint10, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 3, DA_386IGate, hwint11, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 4, DA_386IGate, hwint12, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 5, DA_386IGate, hwint13, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 6, DA_386IGate, hwint14, PRIVILEGE_KERLEL);
	init_idt_desc(INT_VECTOR_IRQ8 + 7, DA_386IGate, hwint15, PRIVILEGE_KERLEL);

	k_print_str("init idt finished\n");
}
