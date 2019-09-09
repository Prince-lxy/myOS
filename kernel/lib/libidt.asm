INT_M_CTL	equ	0x20
INT_M_MASK	equ	0x21
INT_S_CTL	equ	0xa0
INT_S_MASK	equ	0xa1

extern tss
extern stack_top
extern p_process_table

extern exception_handler
extern irq_handler
extern clock_handler

global divide_error
global debug
global nmi
global breakpoint_exception
global overflow
global bounds_range_exceeded
global undefined_opcode
global no_machine
global double_fault
global copr_seg_overrun
global inval_tss
global segment_not_present
global stack_exception
global general_protection
global page_fault
global math_fault
global align_check
global machine_check
global float_point_exception

global hwint00
global hwint01
global hwint02
global hwint03
global hwint04
global hwint05
global hwint06
global hwint07
global hwint08
global hwint09
global hwint10
global hwint11
global hwint12
global hwint13
global hwint14
global hwint15

global process_switching

;; X86 保护模式中断向量表 0x0 - 0x1f
divide_error:
	push 0xffffffff				;; 无错误代码
	push 0					;; 中断向量号 = 0
	jmp exception
debug:
	push 0xffffffff				;; 无错误代码
	push 1					;; 中断向量号 = 1
	jmp exception
nmi:
	push 0xffffffff				;; 无错误代码
	push 2					;; 中断向量号 = 2
	jmp exception
breakpoint_exception:
	push 0xffffffff				;; 无错误代码
	push 3					;; 中断向量号 = 3
	jmp exception
overflow:
	push 0xffffffff				;; 无错误代码
	push 4					;; 中断向量号 = 4
	jmp exception
bounds_range_exceeded:
	push 0xffffffff				;; 无错误代码
	push 5					;; 中断向量号 = 5
	jmp exception
undefined_opcode:
	push 0xffffffff				;; 无错误代码
	push 6					;; 中断向量号 = 6
	jmp exception
no_machine:
	push 0xffffffff				;; 无错误代码
	push 7					;; 中断向量号 = 7
	jmp exception
double_fault:
	push 8					;; 中断向量号 = 8
	jmp exception
copr_seg_overrun:
	push 0xffffffff				;; 无错误代码
	push 9					;; 中断向量号 = 9
	jmp exception
inval_tss:
	push 10					;; 中断向量号 = 10
	jmp exception
segment_not_present:
	push 11					;; 中断向量号 = 11
	jmp exception
stack_exception:
	push 12					;; 中断向量号 = 12
	jmp exception
general_protection:
	push 13					;; 中断向量号 = 13
	jmp exception
page_fault:
	push 14					;; 中断向量号 = 14
	jmp exception
math_fault:
	push 0xffffffff				;; 无错误代码
	push 16					;; 中断向量号 = 16
	jmp exception
align_check:
	push 17					;; 中断向量号 = 17
	jmp exception
machine_check:
	push 0xffffffff				;; 无错误代码
	push 18					;; 中断向量号 = 18
	jmp exception
float_point_exception:
	push 0xffffffff				;; 无错误代码
	push 19					;; 中断向量号 = 19
	jmp exception
exception:
	call exception_handler
	add esp, 4*2				;; 让栈顶指向 eip (eip -> cs -> eflags)
	hlt

re_int	dd	0

;; 8259A 中断控制程序
%macro hwint_handler_master 2
	sub esp, 4
	pushad
	push ds
	push es
	push fs
	push gs

	mov dx, ss				;; kernel level 0
	mov ds, dx
	mov es, dx

	in al, INT_M_MASK			;; disable same irq
	or al, (1 << %1)
	out INT_M_MASK, al

	mov al, INT_M_CTL			;; EOI
	out INT_M_CTL, al

	inc byte [gs:(39 * 2)]

	inc dword [re_int]
	cmp dword [re_int], 1
	jne .end

	mov esp, stack_top			;; kernel stack

	sti
	push %1
	call %2
	add esp, 4
	cli

	in al, INT_M_MASK			;; enable same irq
	and al, ~(1 << %1)
	out INT_M_MASK, al

	dec dword [re_int]
	jmp process_switching
.end:
	dec dword [re_int]
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 4
	iretd
%endmacro

%macro hwint_handler_slave 2
	sub esp, 4
	pushad
	push ds
	push es
	push fs
	push gs

	mov dx, ss				;; kernel level 0
	mov ds, dx
	mov es, dx

	in al, INT_S_MASK			;; disable same irq
	or al, (1 << (%1 - 8))
	out INT_S_MASK, al

	mov al, INT_S_CTL			;; EOI
	out INT_S_CTL, al

	inc byte [gs:(39 * 2)]

	inc dword [re_int]
	cmp dword [re_int], 1
	jne .end

	mov esp, stack_top			;; kernel stack

	sti
	push %1
	call %2
	add esp, 4
	cli

	in al, INT_S_MASK			;; enable same irq
	and al, ~(1 << (%1 - 8))
	out INT_S_MASK, al

	dec dword [re_int]
	jmp process_switching
.end:
	dec dword [re_int]
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 4
	iretd
%endmacro

ALIGN 16
hwint00:					;; irq0 时钟
	hwint_handler_master 0, clock_handler
ALIGN 16
hwint01:					;; irq1 键盘
	hwint_handler_master 1, irq_handler
ALIGN 16
hwint02:					;; irq2 级联从片
	hwint_handler_master 2, irq_handler
ALIGN 16
hwint03:					;; irq3 串口2
	hwint_handler_master 3, irq_handler
ALIGN 16
hwint04:					;; irq4 串口1
	hwint_handler_master 4, irq_handler
ALIGN 16
hwint05:					;; irq5 并口2
	hwint_handler_master 5, irq_handler
ALIGN 16
hwint06:					;; irq6 软盘
	hwint_handler_master 6, irq_handler
ALIGN 16
hwint07:					;; irq7 并口1
	hwint_handler_master 7, irq_handler
ALIGN 16
hwint08:					;; irq8 实时钟
	hwint_handler_slave 8, irq_handler
ALIGN 16
hwint09:					;; irq9 int 0xa
	hwint_handler_slave 9, irq_handler
ALIGN 16
hwint10:					;; irq10 保留
	hwint_handler_slave 10, irq_handler
ALIGN 16
hwint11:					;; irq11 保留
	hwint_handler_slave 11, irq_handler
ALIGN 16
hwint12:					;; irq12 PS2 鼠标
	hwint_handler_slave 12, irq_handler
ALIGN 16
hwint13:					;; irq13 协处理器
	hwint_handler_slave 13, irq_handler
ALIGN 16
hwint14:					;; irq14 硬盘
	hwint_handler_slave 14, irq_handler
ALIGN 16
hwint15:					;; irq15 保留
	hwint_handler_slave 15, irq_handler

process_switching:
	mov esp, [p_process_table]
	lldt [esp + 18 * 4]			;; ldt selector
	lea eax, [esp + 18 * 4]			;; stack top
	mov dword [tss + 4], eax		;; tss.esp0
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 4
	iretd
