loader:
	mov ax, 0xb800
	mov gs, ax
	mov ah, 0xf
	mov al, 'L'
	mov [gs:((80 * 0 + 39) * 2)], ax
	jmp $
