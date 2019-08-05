;; fat12 info
BYTES_PER_SEC		equ	512		;; 字节数/扇区
SEC_PER_TRK		equ	18		;; 扇区数/磁道
DRV_NUM			equ	0		;; 驱动器号

ROOT_DIR_SEC_NUM	equ	14		;; 根目录所占扇区数
SEC_NO_ROOT_DIR		equ 	9		;; 根目录从第 19 号扇区开始
SEC_NO_FAT1		equ	1		;; FAT1 从 1 号扇区开始
DELTA_SEC_NUM		equ	17		;; 1 + 9 + 9 - 2

;; boot
BASE_STACK_BOOT		equ	0x7c00		;; boot 堆栈基地址
BASE_LOADER		equ	0x9000		;; LOADER.BIN 基地址
OFFSET_LOADER		equ	0x100		;; LOADER.BIN 偏移量

;; loader
BASE_STACK_LOADER	equ	0x100		;; loader 堆栈基地址
BASE_KERNEL		equ	0x8000		;; KERNEL.BIN 基地址
OFFSET_KERNEL		equ	0x100		;; KERNEL.BIN 偏移量
