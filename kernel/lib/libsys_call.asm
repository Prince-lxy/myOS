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
	push eax
	push ecx
	push edx
	push ebx
	push esp
	push ebp
	push esi
	push edi
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

	call [sys_call_table + 4 * eax]

	mov esp, [p_process_table]
	lldt [esp + 18 * 4]			;; ldt selector
	lea esi, [esp + 18 * 4]			;; stack top
	mov dword [tss + 4], esi		;; tss.esp0
.end:
	dec dword [re_int_sys_call]
	pop gs
	pop fs
	pop es
	pop ds
	pop edi
	pop esi
	pop ebp
	pop esp
	pop ebx
	pop edx
	pop ecx
	add esp, 8
	iretd
