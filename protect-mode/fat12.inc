;; fat12 info
BYTES_PER_SEC		equ	512		;; 字节数/扇区
SEC_PER_TRK		equ	18		;; 扇区数/磁道
DRV_NUM			equ	0		;; 驱动器号

ROOT_DIR_SEC_NUM	equ	14		;; 根目录所占扇区数
SEC_NO_ROOT_DIR		equ 	9		;; 根目录从第 19 号扇区开始
SEC_NO_FAT1		equ	1		;; FAT1 从 1 号扇区开始
DELTA_SEC_NUM		equ	17		;; 1 + 9 + 9 - 2
