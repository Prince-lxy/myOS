;; Descriptor
;; 
;; |byte 7|byte 6|byte 5|byte 4|byte 3|byte 2|byte 1|byte 0|
;; |Base H|     Attr    |       Base L       |   Limit L   |
;;
;; |              Attr              |
;; |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
;; |G|D|0|A|Limit H||P|DPL|s| TYPE  |
;;
;; usage: DESCRIPTOR Base, Limit, Attr
;; 		%1 Base: dd 32bit
;; 		%2 Limit: dd 32bit (0-20 bit avl)
;; 		%3 Attr: dw 16bit

%macro DESCRIPTOR 3
	dw %2 & 0xffff
	dw %1 & 0xffff
	db (%1 >> 16) & 0xff
	dw ((%2 >> 8) & 0x0f00) | (%3 & 0xf0ff)
	db (%1 >> 24) & 0xff
%endmacro

;; 32-bit segment
%define	DA_32	0x4000

;; Descriptor privilege
%define	DA_DPL0	0x00		;; DPL = 0
%define	DA_DPL1	0x20		;; DPL = 1
%define	DA_DPL2	0x40		;; DPL = 2
%define	DA_DPL3	0x60		;; DPL = 3

;; GDT Code-Segment and Data-Segment Types
%define	DA_DR	0x90		;; Read-Only
%define DA_DRW	0x92		;; Read/Write
%define DA_DRWA	0x93		;; Read/Write, accessed
%define DA_C	0x98		;; Execute-Only
%define	DA_CR	0x9A		;; Execute/Read
%define DA_CCO	0x9C		;; Execute-Only, conforming
%define	DA_CCOR	0x9E		;; Execute/Read-Only, conforming

;; GDT System-Segment and Gate-Descriptor Types
%define	DA_LDT		0x82		;; LDT
%define	DA_TaskGate	0x85		;; Task Gate
%define	DA_386TSS	0x89		;; 32-bit TSS(Available)
%define	DA_386CGate	0x8C		;; 32-bit Call Gate
%define	DA_386IGate	0x8E		;; 32-bit Interrupt Gate
%define	DA_386TGate	0x8F		;; 32-bit Trap Gate

;; Selector Attributes
;;
;; |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
;; |         Index            |T|RPL|
;;
%define	SA_RPL0	0
%define	SA_RPL1	1
%define	SA_RPL2	2
%define	SA_RPL3	3
%define	SA_TIG	0
%define	SA_TIL	4