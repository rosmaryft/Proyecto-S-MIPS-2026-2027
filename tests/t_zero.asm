# tests/t_zero.asm
# Cubre: escritura en $zero (addi, add, lui) y comprobación de que sigue
#        valiendo 0; syscall 11 y syscall 10.
        .text
        li    $t0, 7
        addi  $zero, $zero, 5        # intenta escribir 5
        add   $zero, $t0, $t0        # intenta escribir 14
        lui   $zero, 0x1234          # intenta escribir 0x12340000
        move  $a0, $zero             # $a0 = $zero (debe ser 0)
        addi  $a0, $a0, 48           # + '0' -> imprime '0' si $zero == 0
        li    $v0, 11
        syscall
        add   $a0, $zero, $t0        # $zero + 7 = 7
        addi  $a0, $a0, 48           # '7'
        li    $v0, 11
        syscall
        li    $a0, 10                # salto de linea
        li    $v0, 11
        syscall
        li    $v0, 10
        syscall