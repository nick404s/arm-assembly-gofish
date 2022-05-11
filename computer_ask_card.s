@ computer_ask_card(computer_hand[])
@ Simulates the computer prompt for a card to ask.
@ Asks the first available card in the computer hand.
@ Returns the card.
@ find first card > 0
@ return the card

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data

computer_ask_print: .asciz "The computer asked: %d\n"


@ define the ask_card function
.text
.align 2
.global computer_ask_card 
.type computer_ask_card, %function


computer_ask_card:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ computer_hand[] in r0
	
	@ i = 0
	mov r10, #0
	
computer_ask_card_loop:

	@ check i >= 52 cards
	cmp r10, #52
	
	bge exit_computer_ask_card_loop		@ if i >= num of decks, exit 
	
	@ put the offset value into r3 = i * 4, using left shift
	mov r3, r10, LSL #2	
	@ r3 = array[i]
	ldr r3, [r0, r3] 	@ the card is in r3
	
	@ check if number at array[i] is > 0, save the card to ask
	cmp r3, #0
	bgt save_card

	@ increment the counter: i++
	add r10, r10, #1
	
	@ go to the label
	b computer_ask_card_loop	
	
save_card:

	@ save the card in r5
	mov r5, r3
	
	@ print result
	ldr r0, =computer_ask_print
	mov r1, r5
	bl printf 
	
	@ mov the card into r0 to return
	mov r0, r5
	
	@ break
	b exit_computer_ask_card_loop

exit_computer_ask_card_loop:

    @ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}
