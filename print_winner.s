@ Compares the number of pairs and prints the winner.
@ Takes number of pairs adresses from the user and computer as parameters.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
winner_user: .asciz "\nYou won with %d pairs!\nComputer pairs: %d\n"
winner_computer: .asciz "\nComputer won with %d pairs!\nUser pairs: %d\n"
draw: .asciz "\n>>User pairs: %d !?DRAW!? Computer pairs: %d <<\n"

@ define the print_winner function
.text
.align 2
.global print_winner 
.type print_winner, %function


print_winner:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 contains user number of pairs ptr
	@ load it into r4
	ldr r4, [r0]

	@ r1 contains computer number of pairs ptr
	@ load it into r5
	ldr r5, [r1]
	
	@ check if user win
	cmp r4, r5
	bgt print_user_win
	
	@ check if computer win
	cmp r5, r4
	bgt print_computer_win
	
	@ else: draw?? Print DRAW!
	ldr r0, =draw
	mov r1, r4
	mov r2, r5
	bl printf
	
	b exit_print_winner
	

print_user_win:
	
	ldr r0, =winner_user	
	mov r1, r4
	mov r2, r5
	bl printf
	
	b exit_print_winner

print_computer_win:
	
	ldr r0, =winner_computer
	mov r1, r5
	mov r2, r4
	bl printf
	
	b exit_print_winner
	  
exit_print_winner:
	
	sub sp, fp, #4
    pop {fp, pc}
