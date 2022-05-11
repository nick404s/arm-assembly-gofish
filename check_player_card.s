@ Returns 1 if player card was found, 0 otherwise.
@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
check_card_out: .asciz "%d card was found\n"


@ define the check_player_card function
.text
.align 2
.global check_player_card 
.type check_player_card, %function


check_player_card:

    	@ save LR register
    	push {fp, lr}
	add fp, sp, #4
	
	@ r0 contains the player_array[] ptr	
	@ r1 contains the card to check
	@ save the player_array[] ptr in r4
    	mov r4, r0
    	mov r5, r1    
	
	@ assign flag = 0(false). flag=r5
	mov r5, #0
	
	@ i = 0
	mov r10, #0
	
check_card_loop:

	@ check i >= size of hand(52 CARDS)
	cmp r10, #52
	bge quit_check_card_loop
	
    	@ calculate array byte offset into player array
    	mov r3, r10, LSL #2
    	ldr r3, [r4, r3]

	@ compare if array[i] == card 
	cmp r3, r1
	beq return_true
			
    	add r10, r10, #1	@ i++
	
    	b check_card_loop	
	

return_true:

	@ flag = 1
	mov r5, #1
	@ break
	b quit_check_card_loop

quit_check_card_loop:

	@ DEBUG PRINTING:
	@ldr r0, =check_card_out
	@mov r1, r5
	@bl printf

	@ return the flag
	mov r0, r5 

	@ restore fp, lr registers
    	sub sp, fp, #4
    	pop {fp, pc}

