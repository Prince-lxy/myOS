[SECTION .text]
global memcpy					;; 导出函数

;; memcpy (des_addr, src_addr, size)
memcpy:
	push ebp
	mov ebp, esp

	push edi
	push esi
	push ecx

	mov edi, [ss:ebp + 8]			;; des_addr
	mov esi, [ss:ebp + 12]			;; src_addr
	mov ecx, [ss:ebp + 16]			;; size

memcpy.1:
	cmp ecx, 0
	jz memcpy.2
	mov byte al, [esi]
	inc esi
	mov byte [edi], al
	inc edi
	dec ecx
	jmp memcpy.1

memcpy.2:
	pop ecx
	pop esi
	pop edi
	mov esp, ebp
	pop ebp
	ret
