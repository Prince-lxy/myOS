/* 8259A 中断控制端口 */
#define INT_M_CTL	0x20			// 主 8259A 控制端口
#define INT_M_MASK	0x21			// 主 8259A 中断屏蔽端口

#define INT_S_CTL	0xa0			// 从 8259A 控制端口
#define INT_S_MASK	0xa1			// 从 8259A 中断屏蔽端口

/* 端口读写函数 */
PUBLIC void out_byte(t_port port, t_8 value);
PUBLIC t_8 in_byte(t_port port);
