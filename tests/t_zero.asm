# tests/t_zero.asm
# Cubre: escritura en $zero con addi, add y lui, comprobando despues de
#        cada una que $zero sigue valiendo 0; srl; syscall 11 y 10.
        .text
        li    $t0, 7
        addi  $zero, $zero, 5
        addi  $a0, $zero, 48         # '0' si $zero==0 (si falla: '5')
        li    $v0, 11
        syscall
        add   $zero, $t0, $t0
        addi  $a0, $zero, 48         # '0' (si falla: '>')
        li    $v0, 11
        syscall
        lui   $zero, 0x1234
        srl   $a0, $zero, 16         # 0 (si falla: 0x1234)
        addi  $a0, $a0, 48           # '0' (si falla: 'd')
        li    $v0, 11
        syscall
        add   $a0, $zero, $t0        # 0 + 7
        addi  $a0, $a0, 48           # '7'
        li    $v0, 11
        syscall
        li    $a0, 10
        li    $v0, 11
        syscall
        li    $v0, 10
        syscall