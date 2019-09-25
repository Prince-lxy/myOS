#include "const.h"
#include "type.h"
#include "protect.h"
#include "ports.h"
#include "string.h"

PUBLIC void init_8259a()
{
	/* ICW1 */
	out_byte(INT_M_CTL, 0x11);
	out_byte(INT_S_CTL, 0x11);

	/* ICW2 设置主从片起始中断向量 */
	out_byte(INT_M_MASK, INT_VECTOR_IRQ0);
	out_byte(INT_S_MASK, INT_VECTOR_IRQ8);

	/* ICW3 设置主从片级联 IRQ 号 */
	out_byte(INT_M_MASK, 0x4);
	out_byte(INT_S_MASK, 0x2);

	/* ICW4 80×86模式 */
	out_byte(INT_M_MASK, 0x1);
	out_byte(INT_S_MASK, 0x1);

	/* OCW1 设置中断屏蔽 */
	out_byte(INT_M_MASK, 0xff);
	out_byte(INT_S_MASK, 0xff);

	k_print_str("init 8259A finished\n");
}
