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


ROOT_DIR_SEC_NUM	equ		14			;; 根目录所占扇区数
SEC_NO_ROOT_DIR		equ		19			;; 根目录从第 19 号扇区开始
SEC_NO_FAT1			equ		1			;; FAT1 从 1 号扇区开始
DELTA_SEC_NUM		equ		17			;; 1 + 9 + 9 - 2
