#include "const.h"
#include "type.h"
#include "protect.h"
#include "string.h"
#include "keyboard.h"

PUBLIC t_8		gdt_ptr[6];		// 0-15:limit	16-47:base
PUBLIC DESCRIPTOR	gdt[GDT_SIZE];
PUBLIC t_8		idt_ptr[6];		// 0-15:limit	16-47:base
PUBLIC GATE		idt[IDT_SIZE];

PUBLIC void start()
{
	/* 拷贝GDT */
	memcpy(&gdt, (void*)(*(t_32*)(&gdt_ptr[2])), *((t_16*)(&gdt_ptr[0])));

	/* 更新 gdt_ptr 内容 */
	t_16* p_gdt_limit = (t_16*)(&gdt_ptr[0]);
	t_32* p_gdt_base = (t_32*)(&gdt_ptr[2]);
	*p_gdt_limit = GDT_SIZE * sizeof(DESCRIPTOR);
	*p_gdt_base = (t_32)&gdt;

	/* 修改 SELECTOR_VIDEO 的特权级为 3 */
	gdt[SELECTOR_VIDEO >> 3].attr1 |= DA_DPL3;

	/* 更新 idt_ptr 内容 */
	t_16* p_idt_limit = (t_16*)(&idt_ptr[0]);
	t_32* p_idt_base = (t_32*)(&idt_ptr[2]);
	*p_idt_limit = IDT_SIZE * sizeof(GATE);
	*p_idt_base = (t_32)&idt;

	init_8259a();
	init_idt();
	init_keyboard();

	k_print_str("start finished\n");
}
