.code16							# 使用16位汇编模式

.text
	mov	%cs, %ax
	mov	%ax, %ds
	mov	%ax, %es
	call	DispStr				# 调用显示字符串函数
	jmp	.						# 无限循环
DispStr:
	mov $BootMessage, %ax
	mov %ax, %bp				# es:bp 字符串首地址
	mov $13, %cx				# cx 字符串长度
	mov $0x1301, %ax			# ah = 13h; al = 01h
	mov $0x00c, %bx				# bh 页号; bl 颜色
	mov $0, %dl
	int $0x10
	ret
BootMessage: .ascii "Hello, world!"
.org 510						# 填充到510字节处
.word 0xaa55					# 结束标志
