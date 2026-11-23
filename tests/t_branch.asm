# tests/t_branch.asm
# Cubre: beq y bne tomados y no tomados (incluida una comparacion que solo
#        difiere en los bits altos), un salto hacia atras (bucle con bne),
#        j; syscall 11 y 10.
        .text
main:   li   $s0, 5
        li   $s1, 5
        li   $s2, 6
        li   $s3, 0
        beq  $s0, $s2, f1            # no tomado
        addi $s3, $s3, 1             # se ejecuta: +1
f1:     beq  $s0, $s1, f2            # tomado
        addi $s3, $s3, 16            # NO debe ejecutarse
f2:     bne  $s0, $s1, f3            # no tomado
        addi $s3, $s3, 2             # se ejecuta: +2
f3:     bne  $s0, $s2, f4            # tomado
        addi $s3, $s3, 32            # NO debe ejecutarse
f4:     lui  $s6, 1                  # 0x00010000
        beq  $s6, $zero, f5          # no tomado (difiere solo en bits altos)
        addi $s3, $s3, 4             # se ejecuta: +4
f5:     li   $s4, 0
        li   $s5, 0
loop:   addi $s4, $s4, 1
        add  $s5, $s5, $s4
        bne  $s4, $s0, loop          # hacia atras: 5 vueltas
        j    skip
        addi $s5, $s5, 100           # NO debe ejecutarse
skip:   li   $a1, 32
        move $a0, $s3
        jal  print_hex               # 00000007
        move $a0, $s5
        jal  print_hex               # 0000000f
        li   $a1, 10
        move $a0, $s4
        jal  print_hex               # 00000005
        li   $v0, 10
        syscall

print_hex:                           # igual que en t_alu
        move $t0, $a0
        li   $t1, 8
ph_loop: srl  $t2, $t0, 28
        slti $t3, $t2, 10
        bne  $t3, $zero, ph_dig
        addi $t2, $t2, 87
        j    ph_out
ph_dig: addi $t2, $t2, 48
ph_out: move $a0, $t2
        li   $v0, 11
        syscall
        sll  $t0, $t0, 4
        addi $t1, $t1, -1
        bne  $t1, $zero, ph_loop
        move $a0, $a1
        li   $v0, 11
        syscall
        jr   $ra