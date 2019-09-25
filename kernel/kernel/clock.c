#include "const.h"
#include "type.h"
#include "ports.h"
#include "process.h"
#include "global.h"

PUBLIC t_32		ticks;

PUBLIC void clock_handler(int irq)
{
	ticks++;
	p_process_table->ticks--;

	schedule();
}

PUBLIC void init_clock()
{
	/* 初始化 ticks */
	ticks = 0;

	/* 调整时钟频率 */
	out_byte(TIMER_MODE, RATE_GENERATOR);
	out_byte(TIMER0, (t_8)(TIMER_FREQ/HZ));
	out_byte(TIMER0, (t_8)((TIMER_FREQ/HZ) >> 8));

	set_irq_handler(CLOCK_IRQ, clock_handler);
}
