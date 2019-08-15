SELECTOR_KERNEL_X	equ	0x10

extern c_start
extern gdt_ptr

[section .bss]
kernel_stack:	resb	2 * 1024
stack_top:

[section .text]

global _start					;; 导出 _start
_start:
	mov esp, stack_top			;; 移动 esp 到 kernel 堆栈
	sgdt [gdt_ptr]				;; 存储 gdtr 内容到 gdt_ptr
	call c_start				;; 将 gdt_ptr 重新指向新的 GDT
	lgdt [gdt_ptr]				;; 使用新的 GDT
	jmp SELECTOR_KERNEL_X:K

K:
	mov ah, 0xf
	mov al, 'K'
	mov [gs:((80 * 0 + 39) * 2)], ax
	jmp $
