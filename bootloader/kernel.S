.code16
.text
	mov		$0xb800,%ax
	mov     %ax,%gs
	mov		$0xf,%ah
	mov		$'L',%al
	mov		%ax,%gs:((80*2+0)*2)
	jmp		.
