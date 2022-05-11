@ Initializes the players hand of 52 cards with 0s
@ Takes the players hand array pointer as parameter.

@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data

input_format: .asciz "%d"


@ define the init_array function
.text
.align 2
.global init_array
.type init_array, %function


init_array:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 = array ptr, r1 = 52 number of cards in deck
	mov r1, #52
	@ r10 = i (counter)
	mov r10, #0 			@ i = 0
	
	init_array_loop:
		
		@ check i(r10) vs number of cards(r1)
		cmp r10, r1
		bge exit_init_array		@ if i >= num of cards, exit 
	
		@ else: initialize each memory location with 0
		mov r2, #0			@ r2 = 0
	
		@ put the offset value into r3 = i * 4, using left shift
		mov r3, r10, LSL #2
	
		@ store 0 into r0 with the offset(increment the memory by 4 bytes)
		str r2, [r0, r3]		@ dereference with []
	
		@ increment the counter: i++
		add r10, r10, #1
	
		@ go to the label
		b init_array_loop
	

exit_init_array:
	
	@ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}
