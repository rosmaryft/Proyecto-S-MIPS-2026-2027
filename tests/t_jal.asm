# tests/t_jal.asm
# Cubre: jal y jr con un procedimiento que llama a otro (no hoja), guardando
#        $ra en la pila y retornando; jr a un registro distinto de $ra;
#        lw/sw con $sp; syscall 11 y 10.
        .text
main:   li   $s2, 0
        li   $a1, 32
        li   $a0, 3
        jal  f
        move $a0, $v0
        jal  print_hex               # 00000007
        li   $a0, 10
        jal  f
        move $a0, $v0
        jal  print_hex               # 00000015
        move $a0, $sp
        jal  print_hex               # 00003ffc
        la   $s1, dest
        jr   $s1
        addi $s2, $s2, 100           # NO debe ejecutarse
dest:   li   $a1, 10
        move $a0, $s2
        jal  print_hex               # 00000000
        li   $v0, 10
        syscall

f:      addi $sp, $sp, -4            # f(x) = g(x) + 1
        sw   $ra, 0($sp)
        jal  g
        addi $v0, $v0, 1
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra
g:      add  $v0, $a0, $a0           # g(x) = 2x
        jr   $ra

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