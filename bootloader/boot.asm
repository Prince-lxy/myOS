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

;; readSector
;; 起始扇区 = ax
;; 扇区数 = cl
;; 缓冲区位置 = es:bx
readSector:
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

goOnReading:
	mov ah, 2				;; int 0x13 参数 ：读方法
	mov al, byte [bp - 2] 	;; int 0x13 参数 ：扇区个数
	int 0x13
	jc .goOnReading

	add esp, 2
	pop bp
	
	ret


baseOfStack		equ 0x7c00				;; 堆栈基地址
baseOfLoader	equ 0x9000				;; LOADER.BIN 基地址
offsetOfLoader	equ	0x100				;; LOADER.BIN 偏移量
rootDirSectors	equ	14					;; 根目录所占扇区数
secNoofRootDir	equ	19					;; 根目录从第 19 号扇区开始
secNoOfFAT1		equ	1					;; FAT1 从 1 号扇区开始
deltaSecNo		equ	17					;; 1 + 9 + 9 - 2
