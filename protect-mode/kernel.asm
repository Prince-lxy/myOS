[section .text]
[bits 32]

global _start					;; 导出 _start
_start:
	mov ah, 0xf
	mov al, 'K'
	mov [gs:((80 * 0 + 39) * 2)], ax
	jmp $
