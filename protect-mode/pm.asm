%include "pm.inc"

org 0x7c00
	jmp BEGIN

[SECTION .gdt]
;; GDT
GDT:				DESCRIPTOR 0, 0, 0
DESC_PROTECT_MODE:	DESCRIPTOR 0, protectModeLen - 1, DA_C + DA_32
DESC_VIDEO:			DESCRIPTOR 0xb8000, 0xffff, DA_DRW

gdtLen	equ $ - GDT
gdtPtr	dw gdtLen
		dd 0

;; Selector
selectorProtectMode	equ DESC_PROTECT_MODE - GDT
selectorVideo		equ	DESC_VIDEO - GDT

[SECTION .s16]
[BITS 16]

BEGIN:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax

;; 初始化32位代码段描述符
	xor eax, eax
	mov ax, cs
	shl eax, 4
	add eax, PROTECT_MODE
	mov word [DESC_PROTECT_MODE + 2], ax
	shr eax, 16
	mov byte [DESC_PROTECT_MODE + 4], al
	mov byte [DESC_PROTECT_MODE + 7], ah
	 
;; 加载 gdtr
	xor eax, eax
	mov ax, ds
	shl	eax, 4
	add	eax, GDT
	mov	dword [gdtPtr + 2], eax
	lgdt [gdtPtr]

;; 关闭中断
	cli

;; 打开A20
	in 	al, 0x92
	or 	al, 0x02
	out	0x92, al

;; 切换到保护模式
	mov eax, cr0
	or	eax, 1
	mov cr0, eax

;; 进入保护模式
	jmp dword selectorProtectMode:0

[SECTION .s32]
[BITS 32]

PROTECT_MODE:
	mov ax, selectorVideo
	mov gs, ax
	mov edi, (80 * 0 + 0) * 2
	mov ah, 0x0c
	xor ecx, ecx

.loop:
	mov al, [protectMesg + ecx]
	mov [gs:edi], ax
	add edi, 0x2
	inc ecx
	cmp al, 0x0
	jz .end
	jnc .loop

.end:
	jmp $

protectModeLen equ ($ - PROTECT_MODE)
protectMesg: db "welcome to protect mode!"
endPmsg: db 0

times 510 - 0xba db 0
dw 0xaa55
