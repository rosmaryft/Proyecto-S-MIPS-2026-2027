# tests/t_mem.asm
# Cubre: lw/sw con desplazamiento positivo y negativo;
#        lb/lbu sobre bytes con bit 7 = 1 en las posiciones 0 y 2;
#        sb en las cuatro posiciones de una palabra (d[1:0] = 0,1,2,3)
#        comprobando con lw que los demas bytes no cambian;
#        syscall 11 y 10.
        .data
buf:    .word 0x80FF7F80          # bytes: [0]=80 [1]=7F [2]=FF [3]=80
        .word 0
        .word 0
        .text
main:   la    $s0, buf
        lb    $a0, 0($s0)         # 0xffffff80 (signo)
        jal   print_hex
        lbu   $a0, 0($s0)         # 0x00000080 (ceros)
        jal   print_hex
        lb    $a0, 2($s0)         # 0xffffffff
        jal   print_hex
        lbu   $a0, 2($s0)         # 0x000000ff
        jal   print_hex
        sw    $zero, 4($s0)       # limpia la palabra 1
        li    $t1, 0x11
        sb    $t1, 4($s0)         # posicion 0
        lw    $a0, 4($s0)         # 0x00000011
        jal   print_hex
        li    $t1, 0x22
        sb    $t1, 5($s0)         # posicion 1
        lw    $a0, 4($s0)         # 0x00002211
        jal   print_hex
        li    $t1, 0x33
        sb    $t1, 6($s0)         # posicion 2
        lw    $a0, 4($s0)         # 0x00332211
        jal   print_hex
        li    $t1, 0x44
        sb    $t1, 7($s0)         # posicion 3
        lw    $a0, 4($s0)         # 0x44332211
        jal   print_hex
        li    $t0, 0x12345678
        sw    $t0, 8($s0)         # desplazamiento positivo
        lw    $a0, 8($s0)         # 0x12345678
        jal   print_hex
        addi  $s1, $s0, 16
        lw    $a0, -8($s1)        # desplazamiento negativo: buf+8
        jal   print_hex           # 0x12345678
        li    $v0, 10
        syscall

print_hex:                        # imprime $a0 en 8 digitos hex + '\n'
        move  $t0, $a0
        li    $t1, 8
ph_loop: srl  $t2, $t0, 28
        slti  $t3, $t2, 10
        bne   $t3, $zero, ph_dig
        addi  $t2, $t2, 87        # 'a' - 10
        j     ph_out
ph_dig: addi  $t2, $t2, 48        # '0'
ph_out: move  $a0, $t2
        li    $v0, 11
        syscall
        sll   $t0, $t0, 4
        addi  $t1, $t1, -1
        bne   $t1, $zero, ph_loop
        li    $a0, 10
        li    $v0, 11
        syscall
        jr    $ra