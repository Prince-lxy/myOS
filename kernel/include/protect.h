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
