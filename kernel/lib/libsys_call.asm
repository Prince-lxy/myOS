extern tss
extern stack_top
extern p_process_table
extern sys_call_table

;; syscall
INT_VECTOR_SYS_CALL	equ	0x90

global get_ticks
global sys_call

re_int_sys_call	dd	0

get_ticks:
	mov eax, 0
	int INT_VECTOR_SYS_CALL
	ret

sys_call:
	sub esp, 4
	pushad
	push ds
	push es
	push fs
	push gs

	mov dx, ss				;; kernel level 0
	mov ds, dx
	mov es, dx

	inc dword [re_int_sys_call]
	cmp dword [re_int_sys_call], 1
	jne .end

	mov esp, stack_top			;; kernel stack

	sti
	call [sys_call_table + 4 * eax]
	cli

	mov esp, [p_process_table]
	lldt [esp + 18 * 4]			;; ldt selector
	lea eax, [esp + 18 * 4]			;; stack top
	mov dword [tss + 4], eax		;; tss.esp0
.end:
	dec dword [re_int_sys_call]
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 4
	iretd
