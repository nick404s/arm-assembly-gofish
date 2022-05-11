@ Counts pairs in the hand.
@ Takes the hand adress, number of cards in the hand, the number of pairs adress as parameters.
@ Stores the number of pairs to adress.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8


@ define constants
.data
out_count_pairs: .asciz "\nNumbers of pairs: %d\n"

.text
.align 2
.global count_pairs
.type count_pairs, %function


count_pairs:

    push {fp, lr}
    add fp, sp, #4

    @ r0 = hand array address
    @ r1 = number of cards
    @ r2 = address of number of pairs

    @ load number of pairs into r4 from the adress
    ldr r4, [r2]

    @ r10 = i;
    mov r10, #0   @ init counter variable i for outer loop

    @ nested loop to count pairs
    countpairs_outerloop:

        sub r3, r1, #1
     	cmp r10, r3
        bge end_countpairs_outerloop

        mov r3, r10, LSL #2
        ldr r3, [r0, r3]  @ hand[i] --> r3

        @ if number at the position
        cmp r3, #0
        ble end_countpairs_innerloop

        @  r9 = j
        add r9, r10, #1  @ j = i + 1
    
        countpairs_innerloop:
            cmp r9, r1 @ j >= size of hand
            bge end_countpairs_innerloop

            @ r3 = hand[i]
            mov r5, r9, LSL #2
            ldr r5, [r0, r5]  @ r5 = hand[j]

	        cmp r5, #0
	        ble countpairs_endif

                cmp r3, r5  @ hand[i] == hand[j]
                bne countpairs_endif

                cmp r3, #0
                ble countpairs_endif
                cmp r5, #0
                ble countpairs_endif

                cmp r9, r10
                ble countpairs_endif

                add r4, r4, #1
                @ mov r10, r9

                @ hand[i] = -1; hand[j] = -1
                mov r5, #-1
                mov r3, r10, LSL #2
                str r5, [r0, r3]  @ hand[i] = -1
                mov r3, r9, LSL #2
                str r5, [r0, r3]  @ hand[j] = -1
                mov r3, #-1
                b end_countpairs_innerloop


             countpairs_endif:

                add r9, r9, #1
                b countpairs_innerloop

        end_countpairs_innerloop:

        @ increment count i++
        add r10, r10, #1
        b countpairs_outerloop

    end_countpairs_outerloop:

    @ store the updated number of pairs into adress
    str r4, [r2] 

    @ print the number of pairs
    ldr r0, =out_count_pairs
    mov r1, r4
    bl printf

	@ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}



