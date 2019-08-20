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

extern exception_handler

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
