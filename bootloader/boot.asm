BASE_STACK			equ		0x7c00		;; 堆栈基地址
BASE_LOADER			equ		0x9000		;; LOADER.BIN 基地址
OFFSET_LOADER		equ		0x100		;; LOADER.BIN 偏移量
ROOT_DIR_SEC_NUM	equ		14			;; 根目录所占扇区数
SEC_NO_ROOT_DIR		equ		19			;; 根目录从第 19 号扇区开始
SEC_NO_FAT1			equ		1			;; FAT1 从 1 号扇区开始
DELTA_SEC_NUM		equ		17			;; 1 + 9 + 9 - 2

org 0x7c00
	jmp start
	nop

;; FAT12 HEAD
BS_OEMName			db	"PrinceLY"		;; OEM String, 8 bytes
BPB_BytsPerSec		dw	512				;; 节数/扇区
BPB_SecPerCluster	db	1				;; 扇区数/簇
BPB_ResvdSecCnt		dw	1				;; 保留扇区数，当前内容所占扇区数
BPB_NumFATs			db	2				;; FAT表数目
BPB_RootEntCnt		dw	224				;; 根目录文件数最大值
BPB_TotSec16		dw	2880			;; 扇区总数
BPB_Media			db	0xf0			;; 媒体描述符 1.44 软盘
BPB_FATSz16			dw	9				;; 每个 FAT 表所占用扇区数， 总共占用 18 个扇区
BPB_SecPerTrk		dw	18				;; 扇区数/磁道
BPB_NumHeads		dw	2				;; 磁头数
BPB_HiddSec			dd	0				;; 隐藏扇区数
BPB_TotSec32		dd	0				;; 总扇区数 ???
BS_DrvNum			db	0				;; 驱动器号
BS_Reserved1		db	0				;; 保留
BS_BootSig			db	0x29			;; 扩展标记 ???
BS_VolID			dd	0				;; 卷ID
BS_VolLab			db	"Prince  lxy"	;; 卷标, 11 bytes
BS_FileSysType		db	"FAT12   "		;; 文件系统类型，8 bytes

start:
	mov ax, cs
	mov ds, ax
	mov es,	ax
	mov ss,	ax
	mov sp,	BASE_STACK

	;; 清屏
	mov ax, 0x0600				;; int 0x10 功能6
	mov bx, 0x0700				;; bh = 颜色
	mov cx, 0					;; ch = 起始行 cl = 起始列
	mov dx, 0x184f				;; dh = 结束行 dl = 结束列
	int 0x10

	;; 打印 "Booting and find loader..."
	mov ax, boot_and_find_loader
	mov cx, boot_and_find_loader_len
	call print_str

	;; 重置软盘
	xor ah, ah					;; int 0x13 功能0
	xor dl, dl					;; dl = 驱动器号
	int 0x13

	;; 从根文件系统读取 LOADER.BIN
	mov word [sec_no], SEC_NO_ROOT_DIR

search_in_root_dir:
	cmp word [root_dir_num], 0		;; 14个根目录扇区已经搜索完毕
	jz	not_found
	dec word [root_dir_num]
	
	mov ax, BASE_LOADER
	mov es, ax
	mov bx, OFFSET_LOADER			;; es:bx = LOADER.BIN 缓冲区地址
	mov ax, [sec_no]
	mov cl, 1
	call read_sector				;; 读取扇区号为 sec_no 的根目录分区到 es:bx

	mov si, loader_file_name		;; ds:si = "LOADER  BIN"
	mov di, OFFSET_LOADER			;; es:di = 0x9000 * 0x10 + 0x100 = 0x90100

	cld
	mov dx, 0x10					;; 一个根目录扇区包含文件描述符数目(512 / 32 = 16)
search_file_name:
	cmp dx, 0						;; 一个扇区内16个文件描述符都搜索完毕
	jz goto_next_root_dir_sector
	dec dx
	
	mov cx, 11						;; 文件描述符前11个字节为文件名字符串
compare_file_name:
	cmp cx, 0
	jz filename_found
	dec cx

	lodsb							;; ds:si -> al; si++
	cmp al, byte [es:di]
	jz go_on
	jmp different

go_on:
	inc di
	jmp compare_file_name

different:
	and di, 0xffe0					;; di 重新指向文件名字符串第一个字符
	add di, 0x20					;; di 指向下一个文件描述符
	mov si, loader_file_name		;; ds:si 归位
	jmp search_file_name

goto_next_root_dir_sector:
	add word [sec_no], 1
	jmp search_in_root_dir

not_found:
	;; 打印 "loader not found..."
	mov ax, loader_not_found
	mov cx, loader_not_found_len
	call print_str
	jmp $

filename_found:
	;; 打印 "loader founded..."
	mov ax, loader_founded
	mov cx, loader_founded_len
	call print_str

	;; 打印 "Loading"
	mov ax, loading
	mov cx, loading_len
	call print_str

	mov ax, ROOT_DIR_SEC_NUM
	and di, 0xffe0					;; di 重新指向文件描述符第一个字节
	add di, 0x1a					;; 指向文件描述符中起始 FAT 项
	mov cx, word [es:di]			;; cx = LOADER.BIN 在 FAT 表中 FAT 项号（2）
	push cx

	add	cx, ax
	add cx, DELTA_SEC_NUM			;; cx = LOADER.BIN 内容所在的扇区号
	
	mov ax, BASE_LOADER
	mov es, ax
	mov bx, OFFSET_LOADER			;; es:bx = LOADER.BIN 缓冲区

	mov ax, cx						;; ax = 扇区号
go_on_loading_file:
	push ax
	push bx
	mov ah, 0x0e					;; ah = 0x0e int 0x10 打印字符功能
	mov al, '.'						;; al = 字符
	mov bx, 0x000f					;; bh = 页码 bl = 颜色
	int 0x10
	pop bx
	pop ax

	mov cl, 1
	call read_sector

	pop ax							;; 取出 LOADER.BIN 在 FAT 中的项号
	call get_fat_entry

	cmp ax, 0x0fff
	jz	file_loaded

	push ax
	add ax, ROOT_DIR_SEC_NUM
	add ax, DELTA_SEC_NUM
	add bx, [BPB_BytsPerSec]
	jmp go_on_loading_file

file_loaded:
	jmp $

;; read_sector
;; 起始扇区 = ax
;; 扇区数 = cl
;; 缓冲区位置 = es:bx
read_sector:
	push bp
	mov bp, sp
	
	sub esp, 2				;; 保存扇区数
	mov byte [bp - 2], cl
	push bx					;; 保存缓冲区偏移量

	mov bl, [BPB_SecPerTrk]	;; 除数 18
	div bl					;; ax/bl : al = 商 ah = 余数

	inc ah					;; 起始扇区号
	mov cl, ah				;; int 0x13 参数

	mov dh, al				;; 磁头号
	and dh, 1				;; int 0x13 参数

	shr al, 1				;; 柱面号
	mov ch, al				;; int 0x13 参数

	mov dl, [BS_DrvNum]		;; int 0x13 参数 ：驱动器号

	pop bx					;; int 0x13 参数 ：缓冲区偏移量

go_on_reading:
	mov ah, 2				;; int 0x13 参数 ：读方法
	mov al, byte [bp - 2] 	;; int 0x13 参数 ：扇区个数
	int 0x13
	jc go_on_reading

	add esp, 2
	pop bp
	
	ret

;; print_str
;; ax = 字符串首字母位置
;; cx = 字符串长度
print_str:
	mov bp, ax
	mov ax, ds
	mov es, ax							;; es:bp 字符串
	mov ax, 0x1301						;; int 0x10 打印字符串功能
	mov bx, 0x000c						;; bh = 页码 bl = 颜色
	mov byte dh, [print_line]			;; 行
	mov dl, 0							;; 列
	int 0x10

	inc byte [print_line]

	ret

get_fat_entry:
	push es
	push bx
	push ax

	mov ax, BASE_LOADER
	sub ax, 0x100						;; 基地址在运算时会左移16位，此处为FAT空出来4k空间
	mov es, ax							
	mov bx, 0							;; es:bx = (BASE_LOADER - 100):0
	xor ax, ax
 	mov ax, SEC_NO_FAT1
	mov cl, 2
	call read_sector

	mov byte [flag_odd], 0
	pop ax								;; ax = LOADER.BIN 在 FAT 中的起始项号
	mov bx, 3
	mul bx
	mov bx, 2
	div bx								;; ax = 商 dx = 余数
	cmp dx, 0
	jz	fat_even
	mov byte [flag_odd], 1

fat_even:
	add bx, ax
	mov ax, [es:bx]
	cmp byte [flag_odd], 1
	jnz flat_even_2
	shr ax, 4

flat_even_2:
	and ax, 0x0fff
	pop bx
	pop es
	ret

;; 变量
root_dir_num	dw	ROOT_DIR_SEC_NUM	;; 根目总录扇区数14
sec_no			dw	0					;; 当前扇区号
flag_odd		db	0					;; 是否为奇数
print_line		db	0					;; 字符显示行

loader_file_name		db	"LOADER  BIN"
boot_and_find_loader	db	"Boot and find loader"
boot_and_find_loader_len	equ $ - boot_and_find_loader
loader_founded			db	"Loader founded"
loader_founded_len			equ $ - loader_founded
loader_not_found		db	"Loader not found"
loader_not_found_len		equ $ - loader_not_found
loading					db 	"Loading"
loading_len					equ $ - loading 

times 510 - ($ - $$) db 0
dw 0xaa55
