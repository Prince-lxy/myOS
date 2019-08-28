%include "const.inc"

extern start
extern gdt_ptr
extern idt_ptr
extern init_8259a
extern p_process_A
extern tss
extern main

[section .bss]
kernel_stack:	resb	2 * 1024
stack_top:

[section .text]

global _start					;; 导出 _start
_start:
	mov esp, stack_top			;; 移动 esp 到 kernel 堆栈
	mov ebp, stack_top

	sgdt [gdt_ptr]				;; 存储 gdtr 内容到 gdt_ptr
	call start				;; 将 gdt_ptr 重新指向新的 GDT
	lgdt [gdt_ptr]				;; 加载 gdtr
	lidt [idt_ptr]				;; 加载 idtr

	call main				;; 进入 main 函数

	xor eax, eax
	mov eax, SELECTOR_TSS
	ltr ax					;; 加载 tr

	jmp SELECTOR_KERNEL_X:K

K:
	mov ah, 0xe				;; 颜色（黄色）
	mov al, 'K'
	mov [gs:((80 * 0 + 39) * 2)], ax

	jmp SELECTOR_KERNEL_X:restart

	jmp $

restart:
	mov esp, [p_process_A]
	lldt [esp + 18 * 4]			;; ldt selector
	lea eax, [esp + 18 * 4]			;; stack top
	mov dword [tss + 4], eax
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 4
	iretd
