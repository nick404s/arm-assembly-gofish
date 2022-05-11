@ Calculates remainder of two numbers.
@ Takes to numbers as parameters.
@ Returns the remainder.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

.data

.text
.align 2
.global mod
.type mod, %function

mod:
    push {fp, lr}
    add fp, sp, #4

    @ mod(r0, r1) = r0 % r1

    udiv r2, r0, r1
    mul r2, r1, r2
    sub r2, r0, r2
    mov r0, r2  @ return the remainder

    sub sp, fp, #4
    pop {fp, pc}
