#include "const.h"
#include "type.h"
#include "global.h"

PUBLIC void schedule()
{
	PROCESS* p;
	int greatest_ticks = 0;

	while (!greatest_ticks) {
		for (p = process_table; p < process_table + NUM_TASKS; p++) {
			if (p->ticks > greatest_ticks) {
				greatest_ticks = p->ticks;
				p_process_table = p;
			}
		}

		if (!greatest_ticks) {
			for (p = process_table; p < process_table + NUM_TASKS; p++) {
				p->ticks = p->priority;
			}
		}
	}
}
