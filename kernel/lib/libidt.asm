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

extern exception_handler
extern irq_handler

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

;; 8259A 中断控制程序
%macro hwint_handler 1
	push %1
	call irq_handler
	add esp, 4
	iretd
%endmacro

ALIGN 16
hwint00:					;; irq0 时钟
	hwint_handler 0
ALIGN 16
hwint01:					;; irq1 键盘
	hwint_handler 1
ALIGN 16
hwint02:					;; irq2 级联从片
	hwint_handler 2
ALIGN 16
hwint03:					;; irq3 串口2
	hwint_handler 3
ALIGN 16
hwint04:					;; irq4 串口1
	hwint_handler 4
ALIGN 16
hwint05:					;; irq5 并口2
	hwint_handler 5
ALIGN 16
hwint06:					;; irq6 软盘
	hwint_handler 6
ALIGN 16
hwint07:					;; irq7 并口1
	hwint_handler 7
ALIGN 16
hwint08:					;; irq8 实时钟
	hwint_handler 8
ALIGN 16
hwint09:					;; irq9 int 0xa
	hwint_handler 9
ALIGN 16
hwint10:					;; irq10 保留
	hwint_handler 10
ALIGN 16
hwint11:					;; irq11 保留
	hwint_handler 11
ALIGN 16
hwint12:					;; irq12 PS2 鼠标
	hwint_handler 12
ALIGN 16
hwint13:					;; irq13 协处理器
	hwint_handler 13
ALIGN 16
hwint14:					;; irq14 硬盘
	hwint_handler 14
ALIGN 16
hwint15:					;; irq15 保留
	hwint_handler 15
