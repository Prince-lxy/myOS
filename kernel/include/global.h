EXTERN	t_8		gdt_ptr[6];		// 0-15:limit	16-47:base
EXTERN	DESCRIPTOR	gdt[GDT_SIZE];

EXTERN	t_8		idt_ptr[6];		// 0-15:limit	16-47:base
EXTERN	GATE		idt[IDT_SIZE];
