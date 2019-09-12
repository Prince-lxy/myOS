#ifndef TYPE_H
#define TYPE_H

/* 标准类型 */
typedef unsigned int	t_32;
typedef unsigned short	t_16;
typedef unsigned char	t_8;

/* 端口类型 */
typedef unsigned int    t_port;

/* 函数类型 */
typedef void (*t_int_handler) ();
typedef void (*t_irq_handler) (int irq);
typedef void *t_sys_call;

#endif /* TYPE_H */
