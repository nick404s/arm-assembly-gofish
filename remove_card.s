@ Removes a card from player hand, and puts -1 instead at the position.
@ Takes the player hand array address, size of the array, the card number.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
remove_card_out: .asciz "%d was removed\n"


@ define the remove_card function
.text
.align 2
.global remove_card 
.type remove_card, %function


remove_card:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 contains the player_array[] ptr
    @ r1 contains the size	
	@ r2 contains the card to check
	@ save the size in r5
    @mov r5, r1 
	mov r5, #52	@ 52 cards array_hand[] size   
	
	@ i = 0
	mov r10, #0
	
remove_card_loop:

	@ check i >= size
	cmp r10, r5
	bge quit_remove_card_loop
	
    @ calculate array byte offset into player array
    mov r3, r10, LSL #2
	@ save offset for remove 
	mov r4, r3
	@ load in r3 value of array[i]
    ldr r3, [r0, r3] 	@ r3 = array[i]

	@ compare if array[i] == card 
	cmp r3, r2
	beq remove
			
    add r10, r10, #1	@ i++
	
    b remove_card_loop	
	

remove:
	@ store -1 at the memory address
	mov r6, #-1
	str r6, [r0, r4]    @ array[i] = -1
	
	
	@ DEBUG: print result
	@ldr r0, =remove_card_out
	@mov r1, r3
	@bl printf
	@ END DEBUG.	

	@ break
	b quit_remove_card_loop

quit_remove_card_loop:
	

	@ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}

 
 