#include "type.h"
#include "const.h"
#include "protect.h"

PUBLIC	void* memcpy(void* p_dst, void* p_src, int size);

PUBLIC	t_8		gdt_ptr[6];		// 0-15:limit	16-47:base
PUBLIC	DESCRIPTOR	gdt[GDT_SIZE];

PUBLIC	void c_start()
{
	/* 拷贝GDT */
	memcpy(&gdt, (void*)(*(t_32*)(&gdt_ptr[2])), *((t_16*)(&gdt_ptr[0])));

	/* 更新 gdt_ptr 内容 */
	t_16* p_gdt_limit = (t_16*)(&gdt_ptr[0]);
	t_32* p_gdt_base = (t_32*)(&gdt_ptr[2]);
	*p_gdt_limit = GDT_SIZE * sizeof(DESCRIPTOR);
	*p_gdt_base = (t_32)&gdt;
}
