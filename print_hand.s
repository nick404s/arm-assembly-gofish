@ Prints a hand of player.
@ Takes the hand array adress as parameter.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
printhand_out:    .asciz "%d "
printhand_ret:    .asciz "\n"


@ define the print_hand function
.text
.align 2
.global print_hand
.type print_hand, %function


print_hand:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 contains the hand array adress	
	@ save the adress in r4
    mov r4, r0
    @ save number of cards(52) in r5
	mov r5, #52

	@ initialize counter, i = 0
    mov r10, #0
	
print_hand_loop:

	@ compare i to number of cards in hand
    cmp r10, r5
    bge quit_print_hand_loop

    @ calculate array byte offset into player hand array
    mov r3, r10, LSL #2
    ldr r3, [r4, r3]

	@ check for numbers<=0 to skip printing
	cmp r3, #0
    ble skip_print

    @ printf("%d", card)
    ldr r0, =printhand_out
    mov r1, r3
    bl printf

skip_print:

    @ increment counter
    add r10, r10, #1	@ i++
	
    @ go to the beginning of the loop
    b print_hand_loop

quit_print_hand_loop:

    ldr r0, =printhand_ret
    bl printf

	@ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}

