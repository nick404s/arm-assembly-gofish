@ Asks for a card number from user
@ Returns the number
@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
user_prompt: .asciz "Enter a card to ask: "
ask_card_format: .asciz "%d"


@ define the ask_card function
.text
.align 2
.global ask_card 
.type ask_card, %function


ask_card:

	@ ask_card
	@ return card
    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
    @ call printf("Enter a card to ask: ")
    ldr r0, =user_prompt
    bl printf

    @ scanf("%d", &n)
    @ move stack pointer to save the input number
    sub sp, sp, #4
    mov r1, sp
    ldr r0, =ask_card_format
    bl scanf
	
    @ load into r0 the number from address of stack pointer 
	@ to pass it into main function.
	ldr r0, [sp]  	
	
	

    @ restore fp, lr
    sub sp, fp, #4
    pop {fp, pc}
