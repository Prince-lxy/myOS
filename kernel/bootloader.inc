;; boot
BASE_STACK_BOOT		equ	0x7c00		;; boot 堆栈基地址
BASE_LOADER		equ	0x9000		;; LOADER.BIN 基地址
OFFSET_LOADER		equ	0x100		;; LOADER.BIN 偏移量

;; loader
BASE_STACK_LOADER	equ	0x100		;; loader 堆栈基地址
BASE_KERNEL_ELF		equ	0x8000		;; KERNEL.ELF 基地址
OFFSET_KERNEL_ELF	equ	0x0		;; KERNEL.ELF 偏移量

;; KERNEL.ELF 物理地址
ADDR_KERNEL_ELF		equ	(BASE_KERNEL_ELF * 16 + OFFSET_KERNEL_ELF)

;; kernel
KERNEL_ENTRY		equ	0x30400		;; kernel 入口地址
