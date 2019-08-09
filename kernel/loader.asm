%include "pm.inc"
%include "fat12.inc"

org 0x90100
	jmp start
	nop

[SECTION .gdt]
;; GDT
GDT:			DESCRIPTOR	0, 0, 0
DESC_PROTECT_MODE:	DESCRIPTOR	0, protect_mode_len, DA_X + DA_32
DESC_DATA_PM:		DESCRIPTOR	0, data32_len, DA_DRW + DA_DPL3
DESC_STACK_PM:		DESCRIPTOR	(BASE_LOADER * 16), BASE_STACK_LOADER, DA_DRWA + DA_32
DESC_VIDEO:		DESCRIPTOR	0xb8000, 0xffff, DA_DRW + DA_DPL3
DESC_PRINT:		DESCRIPTOR	0, print32_len, DA_X + DA_32
DESC_LDT:		DESCRIPTOR	0, LDT_LEN, DA_LDT
DESC_CGATE_CODE1:	DESCRIPTOR	0, cgate_code1_len, DA_X + DA_32
DESC_LEVEL3_STACK:	DESCRIPTOR	0, 512, DA_DRWA + DA_32 + DA_DPL3
DESC_LEVEL3_CODE1:	DESCRIPTOR	0, level3_code1_len, DA_X + DA_32 + DA_DPL3
DESC_TSS:		DESCRIPTOR	0, TSS_len, DA_386TSS
DESC_OK:		DESCRIPTOR	0, ok_len, DA_X + DA_32
DESC_PAGE_DIR		DESCRIPTOR	PAGE_DIR_BASE, 4096, DA_DRW
DESC_PAGE_TABLE		DESCRIPTOR	PAGE_TABLE_BASE, 1024, DA_DRW + DA_LIMIT_4K
DESC_SETUP_PAGING	DESCRIPTOR	0, setup_paging_len, DA_X + DA_32

CGATE_1:		GATE		SELECTOR_CGATE_CODE1, 0, 0, DA_386CGate
CGATE_2:		GATE		SELECTOR_PRINT, 0, 0, DA_386CGate + DA_DPL3
CGATE_3:		GATE		SELECTOR_OK, 0, 0, DA_386CGate + DA_DPL3

GDT_LEN		equ	$ - GDT
gdt_ptr		dw	GDT_LEN
		dd	GDT

;; GDT 选择子
SELECTOR_PROTECT_MODE	equ	DESC_PROTECT_MODE - GDT
SELECTOR_DATA_PM	equ	DESC_DATA_PM - GDT
SELECTOR_STACK_PM	equ	DESC_STACK_PM - GDT
SELECTOR_VIDEO		equ	DESC_VIDEO - GDT
SELECTOR_PRINT		equ	DESC_PRINT - GDT
SELECTOR_LDT		equ	DESC_LDT - GDT
SELECTOR_CGATE_CODE1	equ	DESC_CGATE_CODE1 - GDT
SELECTOR_LEVEL3_STACK	equ	DESC_LEVEL3_STACK - GDT + SA_RPL3
SELECTOR_LEVEL3_CODE1	equ	DESC_LEVEL3_CODE1 - GDT + SA_RPL3
SELECTOR_TSS:		equ	DESC_TSS - GDT
SELECTOR_OK:		equ	DESC_OK - GDT
SELECTOR_PAGE_DIR	equ	DESC_PAGE_DIR - GDT
SELECTOR_PAGE_TABLE	equ	DESC_PAGE_TABLE - GDT
SELECTOR_SETUP_PAGING	equ	DESC_SETUP_PAGING - GDT

SELECTOR_GATE_CALL1	equ	CGATE_1 - GDT
SELECTOR_GATE_CALL2	equ	CGATE_2 - GDT + SA_RPL3
SELECTOR_GATE_CALL3	equ	CGATE_3 - GDT + SA_RPL3

[SECTION .ldt]
;; ldt
LDT:
DESC_LDT_CODE1:		DESCRIPTOR	0, ldt_code1_len, DA_X + DA_32

LDT_LEN		equ	$ - LDT
ldt_ptr		dw	LDT_LEN
		dd	LDT

;; LDT 选择子
SELECTOR_LDT_CODE1	equ	DESC_LDT_CODE1 - LDT + SA_TIL

[SECTION .s16]
[BITS 16]

;; 实模式变量
root_dir_num	dw	ROOT_DIR_SEC_NUM	;; 根目总录扇区数14
sec_no		dw	0			;; 当前扇区号
flag_odd	db	0			;; 是否为奇数
print_line	db	3			;; 字符显示行

kernel_file_name		db	"KERNEL  BIN"
find_kernel			db	"find kernel"
find_kernel_len			equ	$ - find_kernel
kernel_found			db	"kernel found"
kernel_found_len		equ	$ - kernel_found
kernel_not_found		db	"kernel not found"
kernel_not_found_len		equ	$ - kernel_not_found
loading				db	"loading"
loading_len			equ	$ - loading

;; read_sector
;; 起始扇区 = ax
;; 扇区数 = cl
;; 缓冲区位置 = es:bx
read_sector:
	push bp
	mov bp, sp
	
	sub esp, 2			;; 保存扇区数
	mov byte [bp - 2], cl
	push bx				;; 保存缓冲区偏移量

	mov bl, SEC_PER_TRK		;; 除数 18
	div bl				;; ax/bl : al = 商 ah = 余数

	inc ah				;; 起始扇区号
	mov cl, ah			;; int 0x13 参数

	mov dh, al			;; 磁头号
	and dh, 1			;; int 0x13 参数

	shr al, 1			;; 柱面号
	mov ch, al			;; int 0x13 参数

	mov dl, DRV_NUM			;; int 0x13 参数 ：驱动器号

	pop bx				;; int 0x13 参数 ：缓冲区偏移量

go_on_reading:
	mov ah, 2			;; int 0x13 参数 ：读方法
	mov al, byte [bp - 2] 		;; int 0x13 参数 ：扇区个数
	int 0x13
	jc go_on_reading

	add esp, 2
	pop bp
	
	ret

;; print_str
;; ax = 字符串首字母位置
;; cx = 字符串长度
print_str:
	push es
	mov bp, ax
	mov ax, ds
	mov es, ax			;; es:bp 字符串
	mov ax, 0x1301			;; int 0x10 打印字符串功能
	mov bx, 0x000c			;; bh = 页码 bl = 颜色
	mov byte dh, [print_line]	;; 行
	mov dl, 0			;; 列
	int 0x10

	inc byte [print_line]

	pop es
	ret

get_fat_entry:
	push es
	push bx
	push ax

	mov ax, BASE_KERNEL
	sub ax, 0x100			;; 基地址在运算时会左移16位，此处为FAT空出来4k空间
	mov es, ax
	mov bx, 0			;; es:bx = (BASE_KERNEL - 100):0
	xor ax, ax
 	mov ax, SEC_NO_FAT1
	mov cl, 2
	call read_sector

	mov byte [flag_odd], 0
	pop ax				;; ax = KERNEL.BIN 在 FAT 中的起始项号
	mov bx, 3
	mul bx
	mov bx, 2
	div bx				;; ax = 商 dx = 余数
	cmp dx, 0
	jz	fat_even
	mov byte [flag_odd], 1

fat_even:
	mov bx, ax
	mov ax, [es:bx]
	cmp byte [flag_odd], 1
	jnz flat_even_2
	shr ax, 4

flat_even_2:
	and ax, 0x0fff
	pop bx
	pop es
	ret

;; 主函数
start:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BASE_STACK_LOADER

	;; 打印 "Booting & find kernel"
	mov ax, find_kernel
	mov cx, find_kernel_len
	call print_str

	;; 重置软盘
	xor ah, ah				;; int 0x13 功能0
	xor dl, dl				;; dl = 驱动器号
	int 0x13

	;; 从根文件系统读取 KERNEL.BIN
	mov word [sec_no], SEC_NO_ROOT_DIR

search_in_root_dir:
	cmp word [root_dir_num], 0		;; 14个根目录扇区已经搜索完毕
	jz	not_found
	dec word [root_dir_num]
	
	mov ax, BASE_KERNEL
	mov es, ax
	mov bx, OFFSET_KERNEL			;; es:bx = KERNEL.BIN 缓冲区地址
	mov ax, [sec_no]
	mov cl, 1
	call read_sector			;; 读取扇区号为 sec_no 的根目录分区到 es:bx

	mov si, kernel_file_name		;; ds:si = "KERNEL  BIN"
	mov di, OFFSET_KERNEL			;; es:di = 0x9000 * 0x10 + 0x100 = 0x90100

	cld
	mov dx, 0x10				;; 一个根目录扇区包含文件描述符数目(512 / 32 = 16)
search_file_name:
	cmp dx, 0				;; 一个扇区内16个文件描述符都搜索完毕
	jz goto_next_root_dir_sector
	dec dx
	
	mov cx, 11				;; 文件描述符前11个字节为文件名字符串
compare_file_name:
	cmp cx, 0
	jz filename_found
	dec cx

	lodsb					;; ds:si -> al; si++
	cmp al, byte [es:di]
	jz go_on
	jmp different

go_on:
	inc di
	jmp compare_file_name

different:
	and di, 0xffe0				;; di 重新指向文件名字符串第一个字符
	add di, 0x20				;; di 指向下一个文件描述符
	mov si, kernel_file_name		;; ds:si 归位
	jmp search_file_name

goto_next_root_dir_sector:
	add word [sec_no], 1
	jmp search_in_root_dir

not_found:
	;; 打印 "kernel not found"
	mov ax, kernel_not_found
	mov cx, kernel_not_found_len
	call print_str
	jmp $

filename_found:
	;; 打印 "kernel found"
	mov ax, kernel_found
	mov cx, kernel_found_len
	call print_str

	;; 打印 "Loading"
	mov ax, loading
	mov cx, loading_len
	call print_str

	mov ax, ROOT_DIR_SEC_NUM
	and di, 0xffe0				;; di 重新指向文件描述符第一个字节
	add di, 0x1a				;; 指向文件描述符中起始 FAT 项
	mov cx, word [es:di]			;; cx = KERNEL.BIN 在 FAT 表中 FAT 项号（2）
	push cx

	add	cx, ax
	add cx, DELTA_SEC_NUM			;; cx = KERNEL.BIN 内容所在的扇区号
	
	mov ax, BASE_KERNEL
	mov es, ax
	mov bx, OFFSET_KERNEL			;; es:bx = KERNEL.BIN 缓冲区

	mov ax, cx				;; ax = 扇区号
go_on_loading_file:
	push ax
	push bx
	mov ah, 0x0e				;; ah = 0x0e int 0x10 打印字符功能
	mov al, '.'				;; al = 字符
	mov bx, 0x000f				;; bh = 页码 bl = 颜色
	int 0x10
	pop bx
	pop ax

	mov cl, 1
	call read_sector

	pop ax					;; 取出 KERNEL.BIN 在 FAT 中的项号
	call get_fat_entry

	cmp ax, 0x0fff
	jz	file_loaded

	push ax
	add ax, ROOT_DIR_SEC_NUM
	add ax, DELTA_SEC_NUM
	add bx, BYTES_PER_SEC
	jmp go_on_loading_file

file_loaded:
	;; 初始化段描述符
	INITDESC DESC_PROTECT_MODE, protect_mode

	INITDESC DESC_DATA_PM, data32

	INITDESC DESC_PRINT, print32

	INITDESC DESC_LDT_CODE1, ldt_code1

	INITDESC DESC_LDT, LDT

	INITDESC DESC_CGATE_CODE1, cgate_code1

	INITDESC DESC_LEVEL3_STACK, level3_stack

	INITDESC DESC_LEVEL3_CODE1, level3_code1

	INITDESC DESC_TSS, TSS

	INITDESC DESC_OK, ok

	INITDESC DESC_SETUP_PAGING, setup_paging

	;; 加载 gdtr
	lgdt [gdt_ptr]

	;; 关闭中断
	cli

	;; 打开 A20
	in al, 0x92
	or al, 0x02
	out 0x92, al

	;; 切换到保护模式
	mov eax, cr0
	or  eax, 1
	mov cr0, eax

	;; 进入保护模式
	jmp dword SELECTOR_PROTECT_MODE:0

	;jmp BASE_KERNEL:OFFSET_KERNEL

;; ============================== 32 位保护模式 ==============================

[SECTION .s32]
[BITS 32]

;; 保护模式变量
data32:
pm_print_line		dd	0x00000006
join_pm			db	"join protect mode now.", 0
print_ok		db	"OK!", 0
join_ldt_code1		db	"join ldt code 1 now -->", 0
exit_ldt_code1		db	"exit ldt code 1 now <--", 0
join_cgate_code1	db	"join call gate code 1 now -->", 0
exit_cgate_code1	db	"exit call gate code 1 now <--", 0
level3_cgate_level0	db	"level 3 use call gate to call level 0 code.", 0
setup_paging_start	db	"setup paging start -->", 0
setup_paging_finish	db	"setup paging finish <--", 0
data32_len		equ	$ - $$

;; TSS
TSS:
	DD	0				;; back
	DD	BASE_STACK_LOADER		;; 0 级堆栈
	DD	SELECTOR_STACK_PM
	DD	0				;; 1 级堆栈
	DD	0
	DD	0				;; 2 级堆栈
	DD	0
	DD	0				;; cr3
	DD	0				;; eip
	DD	0				;; eflags
	DD	0				;; eax
	DD	0				;; ecx
	DD	0				;; edx
	DD	0				;; ebx
	DD	0				;; esp
	DD	0				;; ebp
	DD	0				;; esi
	DD	0				;; edi
	DD	0				;; es
	DD	0				;; cs
	DD	0				;; ss
	DD	0				;; ds
	DD	0				;; fs
	DD	0				;; gs
	DD	0				;; LDT
	Dw	0				;; 调试陷阱标志
	Dw	$ - TSS + 2			;; I/o 位图基地址
	Dw	0xff				;; I/O 位图结束标志
TSS_len:	equ	$ - TSS

;; level 3 stack
ALIGN	32
level3_stack:
	times 512 db 0
top_level3_stack	equ	$ - level3_stack

;; setup paging
setup_paging:
	;; 打印 setup paging start
	mov esi, (setup_paging_start - data32)
	call SELECTOR_PRINT:0

	;; 初始化页目录
	mov ax, SELECTOR_PAGE_DIR
	mov es, ax
	mov ecx, 1024				;; 一共1024个页表
	xor edi, edi
	xor eax, eax
	mov eax, PAGE_TABLE_BASE | PG_P | PG_USU | PG_RWW
.1:
	stosd
	add eax, 4096
	loop .1

	;; 初始化所有页表（1024个）
	mov ax, SELECTOR_PAGE_TABLE
	mov es, ax
	mov ecx, 1024 * 1024
	xor edi, edi
	xor eax, eax
	mov eax, PG_P | PG_USU | PG_RWW
.2:
	stosd
	add eax, 4096
	loop .2

	mov eax, PAGE_DIR_BASE
	mov cr3, eax
	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax

	;; 打印 setup paging finish
	mov esi, (setup_paging_finish - data32)
	call SELECTOR_PRINT:0

	;返回
	retf
setup_paging_len	equ	$ - setup_paging

;; level 3 code 1
level3_code1:
	;; 打印 join to protect mode
	mov esi, (level3_cgate_level0 - data32)
	call SELECTOR_GATE_CALL2:0

	;返回特权级 0
	call SELECTOR_GATE_CALL3:0
level3_code1_len	equ	$ - level3_code1

;; call gate code 1
cgate_code1:
	;; 进入函数
	mov esi, (join_cgate_code1 - data32)
	call SELECTOR_PRINT:0

	;; 离开函数
	mov esi, (exit_cgate_code1 - data32)
	call SELECTOR_PRINT:0

	;; 返回保护模式主函数
	retf
cgate_code1_len	equ $ - cgate_code1

;; ldt code 1
ldt_code1:
	;; 进入函数
	mov esi, (join_ldt_code1 - data32)
	call SELECTOR_PRINT:0

	;; 离开函数
	mov esi, (exit_ldt_code1 - data32)
	call SELECTOR_PRINT:0

	;; 返回保护模式主函数
	retf
ldt_code1_len	equ $ - ldt_code1

;; print32
;; esi = 字符串首地址
print32:
	push eax
	push ebx
	push ecx
	xor eax, eax
	xor ebx, ebx
	mov word ax, [pm_print_line - data32]
	mov bx, 160
	mul bx
	mov edi, eax
	mov ah, 0x0c
	xor ecx, ecx
.loop:
	mov al, [ds:esi + ecx]
	mov [gs:edi], ax
	add edi, 2
	inc ecx
	cmp al, 0
	jz	.end
	jnc	.loop

.end:
	inc dword [pm_print_line - data32]

	pop ecx
	pop ebx
	pop eax
	retf
print32_len	equ	$ - print32

;; 保护模式开始
protect_mode:
	mov ax, SELECTOR_DATA_PM
	mov ds, ax					;; ds = 数据段
	mov ax, SELECTOR_VIDEO
	mov gs, ax					;; gs = 显存段
	mov ax, SELECTOR_STACK_PM
	mov ss, ax					;; ss = 堆栈段
	mov esp, BASE_STACK_LOADER

	;; 打印 join to protect mode
	mov esi, (join_pm - data32)
	call SELECTOR_PRINT:0

	;; 加载 ldtr
	mov ax, SELECTOR_LDT
	lldt ax

	;jmp SELECTOR_LDT_CODE1:0
	call SELECTOR_LDT_CODE1:0

	;; 测试调用门
	call SELECTOR_GATE_CALL1:0

	;; 进入 level 3
	mov ax, SELECTOR_TSS
	ltr ax

	push SELECTOR_LEVEL3_STACK		;; level 3 ss
	push top_level3_stack			;; level 3 esp
	push SELECTOR_LEVEL3_CODE1		;; level 3 cs
	push 0					;; level 3 eip
	retf
protect_mode_len	equ	$ - protect_mode

;; 打印 ok!
ok:
	;; setup paging
	call SELECTOR_SETUP_PAGING:0

	mov esi, (print_ok - data32)
	call SELECTOR_PRINT:0

	jmp $
ok_len			equ	$ - ok
