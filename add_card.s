@ add_card(player_hand[], card
@ Adds a card to player hand array
@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
out_add_card: .asciz "%d was added\n"

@ define the add_card function
.text
.align 2
.global add_card
.type add_card, %function

add_card:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4

	@ r0 = array ptr, r1 = new_card, r2 = 52 number of cards
	mov r2, #52
	@ r10 = i (counter)
	mov r10, #0 			@ i = 0
	
add_card_loop:
		
	@ check i vs number of cards
	cmp r10, r2
	bge exit_add_card		@ if i >= num of decks, exit 
	
	@ else: check if number at array[i] is <= 0, and assign it to new card
	
	@ put the offset value into r3 = i * 4, using left shift
	mov r3, r10, LSL #2	
	@ r3 = array[i]
	ldr r3, [r0, r3]

	cmp r3, #0
	ble assign_card

	@ increment the counter: i++
	add r10, r10, #1
	
	@ go to the label
	b add_card_loop

assign_card:

	@ calculate offset
	mov r3, r10, LSL #2
	
	@ store the card
	str r1, [r0, r3]		@ array[i] = new_card
	
	@ DEBUG: print result
	@ldr r1, [r0, r3]
	@ldr r0, =out_add_card
	@bl printf
	@ End of DEBUG
	
	@ break
	b exit_add_card

exit_add_card:
	
	@ restore fp, lr registers
    	sub sp, fp, #4
    	pop {fp, pc}
