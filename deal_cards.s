@ Deals cards.
@ Reads 5 card numbers from the text file and populates the player hand array.
@Takes player array, file pointer

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
deal_cards_read: .asciz "%d"


@ define the deal_cards function
.text
.align 2
.global deal_cards 
.type deal_cards, %function


deal_cards:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 contains the card_array[] ptr
    @ r1 contains the deck_file ptr	
	@ save the values in r4 and r5
    mov r4, r0
    mov r5, r1    
	
    sub sp, sp, #4  @ allocate a memory location on stack for input card
	
	@ i = 0
	mov r10, #0
	
deal_cards_loop:

	@ check for 5 cards in the player_hand
    cmp r10, #5
    bge quit_deal_cards_loop

    @ fscanf(file pointer, "%d", address to memory location)
    mov r0, r5			@ file_ptr -> r0
    ldr r1, =deal_cards_read
    mov r2, sp  @ move memory location in r2
    bl fscanf

    @ store the file input into array
    @ calculate offset
    mov r3, r10, LSL #2
    ldr r2, [sp]  @ load the card from file into r2
    str r2, [r4, r3]   @ store the card value into the array index at r10
 
	@ i++
    add r10, r10, #1
    b deal_cards_loop
	        
quit_deal_cards_loop:

    @ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}

