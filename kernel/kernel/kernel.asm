SELECTOR_KERNEL_X	equ	0x10

extern c_start
extern gdt_ptr
extern idt_ptr
extern init_8259a

[section .bss]
kernel_stack:	resb	2 * 1024
stack_top:

[section .text]

global _start					;; 导出 _start
_start:
	mov esp, stack_top			;; 移动 esp 到 kernel 堆栈
	mov ebp, stack_top

	sgdt [gdt_ptr]				;; 存储 gdtr 内容到 gdt_ptr
	call c_start				;; 将 gdt_ptr 重新指向新的 GDT
	lgdt [gdt_ptr]				;; 使用新的 GDT

	lidt [idt_ptr]				;; 加载 idtr

	jmp SELECTOR_KERNEL_X:K

K:
	mov ah, 0xe				;; 颜色（黄色）
	mov al, 'K'
	mov [gs:((80 * 0 + 39) * 2)], ax

	jmp $
