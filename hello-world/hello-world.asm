start:
	org 0x7c00

	;; es:bp = 字符串首地址
	mov ax, cx
	mov es, ax
	mov ax, msg
	mov bp, ax

	mov ax, 0x1301		;; ah = 功能代码 al = 写模式
	mov bx, 0x000c		;; bh = 页码 bl = 颜色
	mov cx, msgLen	;; cx = 字符串长度
	mov dx, 0x0000		;; dh = 行 dl = 列
	int 0x10
	jmp $

msg: db "hello world, wooooooool!!!"
msgLen: equ $ - msg	

times 510 - ($ - start) db 0
dw 0xaa55
