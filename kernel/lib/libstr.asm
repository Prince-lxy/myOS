;; 导出函数
global memcpy
global k_print_str

global k_print_pos

[SECTION .data]
k_print_pos	dd	160 * 10

[SECTION .text]

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

;; k_print_str ("str")
k_print_str:
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]			;; 字符串首地址
	mov edi, [k_print_pos]
	mov ah, 0xa				;; 颜色（浅绿色）

k_print_str.1:
	lodsb
	test al, al
	jz k_print_str.2
	cmp al, 0xa				;; 是否为回车
	jnz k_print_str.3
	push eax
	mov eax, edi
	mov bl, 160
	div bl
	and eax, 0xff
	inc eax
	mov bl, 160
	mul bl
	mov edi, eax
	pop eax
	jmp k_print_str.1

k_print_str.3:
	mov [gs:edi], ax
	add edi, 2
	jmp k_print_str.1

k_print_str.2:
	mov [k_print_pos], edi
	pop ebp

	ret
