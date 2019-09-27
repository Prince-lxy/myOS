#ifndef STRING_H
#define STRING_H

#include "const.h"

PUBLIC void* memcpy(void* p_dst, void* p_src, int size);
PUBLIC void* memset(void *s, int c, int n);
PUBLIC void k_print_str(char * str);
PUBLIC void k_print_hex(int num);
PUBLIC void print_str(char * str);
PUBLIC void print_hex(int num);
PUBLIC void clear();

#endif /* STRING_H */
