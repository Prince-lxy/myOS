global out_byte
global in_byte

out_byte:
	mov edx, [esp + 4]			;; port
	mov al, [esp + 8]			;; value
	out dx, al
	nop
	nop
	ret

in_byte:
	mov edx, [esp + 4]			;; port
	xor eax, eax
	in al, dx
	nop
	nop
	ret
