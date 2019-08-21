/* 段描述符 */
typedef struct s_descriptor
{
	t_16	limit_low;			// LIMIT
	t_16	base_low;			// BASE
	t_8	base_mid;			// BASE
	t_8	attr1;				// P(1) DPL(2) DT(1) TYPE(4)
	t_8	limit_high_attr2;		// G(1) D(1) 0(1) AVL(1) limithigh(4)
	t_8	base_high;			// BASE
}DESCRIPTOR;

/* 门描述符 */
typedef struct s_gate
{
	t_16	offset_low;			// OFFSET LOW
	t_16	selector;			// SELECTOR
	t_8	dcount;				// 仅调用门可用
	t_8	attr;				// P(1) DPL(2) DT(1) TYPE(4)
	t_16	offset_high;			// OFFSET HIGH
}GATE;

/* 段描述符属性 */
#define DA_32		0x4000
#define DA_LIMIT_4K	0x8000

#define	DA_DPL0			0x00		// DPL = 0
#define	DA_DPL1			0x20		// DPL = 1
#define	DA_DPL2			0x40		// DPL = 2
#define	DA_DPL3			0x60		// DPL = 3
#define	PRIVILEGE_KERLEL	0x00		// DPL = 0

#define	DA_DR			0x90		// Read-Only
#define	DA_DRW			0x92		// Read/Write
#define	DA_DRWA			0x93		// Read/Write, accessed
#define	DA_X			0x98		// Execute-Only
#define	DA_XR			0x9A		// Execute/Read
#define	DA_XCO			0x9C		// Execute-Only, conforming
#define	DA_XCOR			0x9E		// Execute/Read-Only, conforming

#define	DA_LDT			0x82		// LDT
#define	DA_TaskGate		0x85		// Task Gate
#define	DA_386TSS		0x89		// 32-bit TSS(Available)
#define	DA_386CGate		0x8C		// 32-bit Call Gate
#define	DA_386IGate		0x8E		// 32-bit Interrupt Gate
#define	DA_386TGate		0x8F		// 32-bit Trap Gate

#define SELECTOR_KERNEL_X	0x10

/* 中断向量 */
#define INT_VECTOR_IRQ0         0x20
#define INT_VECTOR_IRQ8         0x28

/* 中断处理函数 */
void divide_error();
void debug();
void nmi();
void breakpoint_exception();
void overflow();
void bounds_range_exceeded();
void undefined_opcode();
void no_machine();
void double_fault();
void copr_seg_overrun();
void inval_tss();
void segment_not_present();
void stack_exception();
void general_protection();
void page_fault();
void math_fault();
void align_check();
void machine_check();
void float_point_exception();

void hwint00();
void hwint01();
void hwint02();
void hwint03();
void hwint04();
void hwint05();
void hwint06();
void hwint07();
void hwint08();
void hwint09();
void hwint10();
void hwint11();
void hwint12();
void hwint13();
void hwint14();
void hwint15();

PUBLIC void init_idt();
PUBLIC void init_8259a();
