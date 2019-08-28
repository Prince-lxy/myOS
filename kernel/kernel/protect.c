#include "const.h"
#include "type.h"
#include "global.h"

PUBLIC void init_descriptor(DESCRIPTOR * p_desc, t_32 base, t_32 limit, t_16 attribute)
{
	p_desc->limit_low = limit&0xffff;
	p_desc->base_low = base&0xffff;
	p_desc->base_mid = (base >> 16) & 0xff;
	p_desc->attr1 = attribute & 0xff;
	p_desc->limit_high_attr2 = ((limit >> 16) & 0x0f) | (attribute >> 8) & 0xf0;
	p_desc->base_high = (base >> 24) & 0xff;
}

PUBLIC t_32 seg2phys(t_16 seg)
{
	DESCRIPTOR* p_desc = &gdt[seg >> 3];
	return (p_desc->base_high << 24) | (p_desc->base_mid << 16) | (p_desc->base_low);
}
