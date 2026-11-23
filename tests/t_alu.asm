# tests/t_alu.asm
# Cubre: add/sub con positivos y con negativo; and/or con unos en los 16 bits
#        altos; slt/slti con resultado 1 y 0 y operando negativo (con signo
#        != sin signo); sll/srl con shamt 0 y !=0, srl sobre negativo;
#        addi con inmediato negativo; andi/ori/lui con inmediato de bit 15=1;
#        addu/addiu via move y li; syscall 11 y 10.
        .text
main:   li   $s0, 100
        li   $s1, -7
        li   $s2, 7
        li   $s3, 30
        li   $s4, 0xF0F0F0F0
        li   $s5, 0xFF00FF00
        lui  $s6, 1                  # 0x00010000
        li   $s7, -16                # 0xfffffff0
        # linea 1: add/sub
        li   $a1, 32
        add  $a0, $s0, $s2
        jal  print_hex               # 0000006b
        add  $a0, $s0, $s1
        jal  print_hex               # 0000005d
        sub  $a0, $s0, $s3
        jal  print_hex               # 00000046
        li   $a1, 10
        sub  $a0, $s1, $s0
        jal  print_hex               # ffffff95
        # linea 2: and/or
        li   $a1, 32
        and  $a0, $s4, $s5
        jal  print_hex               # f000f000
        li   $a1, 10
        or   $a0, $s4, $s5
        jal  print_hex               # fff0fff0
        # linea 3: slt/slti
        li   $a1, 32
        slt  $a0, $s1, $s0
        jal  print_hex               # 00000001
        slt  $a0, $s0, $s1
        jal  print_hex               # 00000000
        slti $a0, $s1, 5
        jal  print_hex               # 00000001
        slti $a0, $s0, 5
        jal  print_hex               # 00000000
        li   $a1, 10
        slti $a0, $s1, -5
        jal  print_hex               # 00000001
        # linea 4: desplazamientos
        li   $a1, 32
        sll  $a0, $s0, 0
        jal  print_hex               # 00000064
        sll  $a0, $s0, 4
        jal  print_hex               # 00000640
        sll  $a0, $s1, 28
        jal  print_hex               # 90000000
        srl  $a0, $s7, 0
        jal  print_hex               # fffffff0
        li   $a1, 10
        srl  $a0, $s7, 4
        jal  print_hex               # 0fffffff
        # linea 5: inmediatos
        li   $a1, 32
        addi $a0, $s0, -1
        jal  print_hex               # 00000063
        addi $a0, $s1, -3
        jal  print_hex               # fffffff6
        andi $a0, $s4, 0x8001
        jal  print_hex               # 00008000
        ori  $a0, $s6, 0x8001
        jal  print_hex               # 00018001
        li   $a1, 10
        lui  $a0, 0xF0F0
        jal  print_hex               # f0f00000
        # linea 6: addu/addiu (move y li)
        li   $a1, 32
        move $a0, $s1
        jal  print_hex               # fffffff9
        li   $a0, -32768
        jal  print_hex               # ffff8000
        li   $a1, 10
        li   $a0, 32767
        jal  print_hex               # 00007fff
        li   $v0, 10
        syscall

print_hex:                           # imprime $a0 en 8 hex y luego el char $a1
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