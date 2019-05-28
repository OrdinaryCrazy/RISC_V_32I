.org 0x0
 	.global _start
_start:
    addi t0, zero, 0    ;0
    addi t1, zero, 0    ;4
    addi t2, zero, 0    ;8
    addi t3, zero, 10   ;12
for_out: 
    addi t2, t2, 1      ;16
for_in:
    add  t1, t1, t0         ;20
    addi t0, t0, 1          ;24
    bne  t0, t3, for_in     ;28
    addi t0, zero, 0        ;32
    bne  t2, t3, for_out    ;36
    addi t1, t1, 1          ;40
