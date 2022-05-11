@ Reads file, returns a card number for a player.
@ Takes a file pointer as parameter.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
fish_read: .asciz "%d"
fish_print: .asciz "Draw in fish: %d\n"


@ define the fish function
.text
.align 2
.global fish 
.type fish, %function


fish:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4

    @ r0 contains the deck_file ptr	
	@ save the values in r4 and r5
    mov r4, r0
    mov r5, r1    
	
    sub sp, sp, #4  @ allocate a free mem location on stack to get user input
	

    @ fscanf(file pointer, "%d", &card)
    mov r0, r4					@ file_ptr -> r0
    ldr r1, =fish_read			@ "%d"
    mov r2, sp  				@ &card -> r2
    bl fscanf


	@ DEBUG: print the card
	@ldr r0, =fish_print
	@ldr r1, [sp]
	@bl printf
	@ DEBUG END.

    ldr r0, [sp]  @ load the card from file into r0 to return


    @ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}
