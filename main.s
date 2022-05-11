@ Go Fish.
@ A program that simulates Go Fish card game for 2 players: user vs computer.
@ All cards represented as integer numbers from 1 to 13 for each suit.
@ The card numbers are randomly generated and kept in a text file.
@ Ends when no cards left in the deck(the text file).
@ Winner has the most number of pairs.


@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
deck_file_name: .asciz "deck.txt"
write_format: .asciz "w"
main_read:   .asciz "r"
player_1: .asciz "User: "
player_2: .asciz "Computer: "
exiting: .asciz "Exiting..\n"
go_fish_print: .asciz "Go Fish!\n"
user_print: .asciz "======================USER===================\n"
comp_print: .asciz "======================COMPUTER===================\n"
draw_fish_print: .asciz "You draw: %d\n"
card_from_computer_print: .asciz "You got from the computer: %d\n"

@ define the main function
.text
.align 2
.global main
.type main, %function


main:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ reset seed in random generator
	mov r0, #0
	bl time
	bl srand
	
	@ allocate memory for all elements
	sub sp, sp, #28		@ allocate memory for the pointers
	
	@ player hand[] 52 cards
	sub sp, sp, #208 			@ allocate memory for the user hand 52 cards
	@ store address of player1_hand[] ptr, address of array for player1
	str sp, [fp, #-12]
	@ computer hand[] 52 cards
	sub sp, sp, #208 			@ allocate memory for the computer hand 52 card
	@ store address of player2_hand[] ptr, address of array for computer
	str sp, [fp, #-16]
	
	@ store size of 52 cards for each players hand
	mov r0, #52
	str r0, [fp, #-20]
	str r0, [fp, #-24]
	
	mov r0, #0   @ initialize each player number of pairs with 0
    str r0, [fp, #-28]   @ store the number of pairs for user
    str r0, [fp, #-32]   @ store the number of pairs for computer


	@ initialize the players hands of 52 cards with 0s
	ldr r0, [fp, #-12]   @ user hand
	bl init_array
	ldr r0, [fp, #-16]	@ computer hand
	bl init_array
	
	
	@ file_ptr = fopen("deck.txt", "w")
	ldr r0, =deck_file_name
	ldr r1, =write_format
	bl fopen					@ returns file_ptr -> r0
	@ store the file_ptr from fopen to the stack
	str r0, [fp, #-8]
	
	
	@ shuffle_deck(file_ptr)
	ldr r0, [fp, #-8]			@ load the file_ptr into shuffle()
	bl shuffle_deck
	
	@ close the file fclose()
	ldr r0, [fp, #-8]
	bl fclose
	
	@ reopen to read the file fopen(file_ptr, file_ptr)
	ldr r0, =deck_file_name
    ldr r1, =main_read
    bl fopen  @ r0 contains the file pointer
	
    @ store the file pointer back into [fp, #-8]
    str r0, [fp, #-8]

    @ deal cards to player
    @ dealcard(player array, file pointer)
    ldr r0, [fp, #-12]
    ldr r1, [fp, #-8]
    bl deal_cards  @ deal 5 cards to player	
	
    @ deal cards to computer
    ldr r0, [fp, #-16]
    ldr r1, [fp, #-8]
    bl deal_cards  @ deal 5 cards to computer
	
    @ DEBUG START: print player2_hand
    @ldr r0, [fp, #-16]   @ computer hand
    @ldr r1, [fp, #-24]   @ number of cards in computer hand
    @bl print_hand
	@ DEBUG END.


    @ USER  header
    ldr r0, =player_1
    @branch to printf
    bl printf
	
    @ count pairs for user
    ldr r0, [fp, #-12]   @ address of user's array
    ldr r1, [fp, #-20]   @ number of user cards
    sub r2, fp, #28      @ address of user number of pairs
    bl count_pairs


    @ print players hand 
    ldr r0, [fp, #-12]   @ user hand
    ldr r1, [fp, #-20]   @ number of cards in user hand
    bl print_hand

    @ COMPUTER header
    ldr r0, =player_2
    @branch to printf
    bl printf
	
    @ count pairs for computer
    ldr r0, [fp, #-16]   @ address of computer array
    ldr r1, [fp, #-24]   @ number of computer cards
    sub r2, fp, #32      @ address of computer number of pairs
    bl count_pairs
	
    @ DEBUG START: print player2_hand
    @ldr r0, [fp, #-16]   @ computer hand
    @ldr r1, [fp, #-24]   @ number of cards in computer hand
    @bl print_hand
	@ DEBUG END.

	@ initialize the count_deck with 10
	@ since 10 cards were dealt. To know how many cards were taken from the deck(file).
	@ r8 = count_deck
	mov r8, #10

game_loop:

	@ check count_deck, if count_deck>=52-> end_game
	cmp r8, #52
	bge end_game

	@ print border for user turn
	ldr r0, =user_print
	bl printf

    @ USER starts first
    @ user ask_card
    bl ask_card 		@ returns a card in r0

    @ save the card in r7 
    mov r7, r0

    @ check if the card is in computer hand -> true = 1, false = 0
    ldr r0, [fp, #-16]   @ address of computer array
    mov r1, r7			@ the card
    bl check_player_card

	@ if true(1):
	cmp r0, #1
	beq transfer_card_to_user

	@ check if the count >= 52 cards -> end of game
	cmp r8, #52
	bge end_game

	
	@ else: print go fish
	ldr r0, =go_fish_print
	bl printf

    @ go fish(file_ptr) -> returns a card from file
	ldr r0, [fp, #-8]		@ load the file_ptr into fish()
	bl fish					@ returns a card in r0

	@ save the card from fish
	mov r7, r0

	@ print the card
	ldr r0, =draw_fish_print
	mov r1, r7
	bl printf

	@ add the card to user hand
	mov r1, r7				@ move the card into r1 to pass into add_card()
    ldr r0, [fp, #-12]   	@ user hand
    bl add_card				@ call add_card

    @ count pairs for user
    ldr r0, [fp, #-12]   @ address of user array
    ldr r1, [fp, #-20]   @ number of user cards
    sub r2, fp, #28      @ address of user number of pairs
    bl count_pairs

    @ USER DEBUG START player header
    ldr r0, =player_1
    @branch to printf
    bl printf
    @ print user hand 
    ldr r0, [fp, #-12]   @ user hand
    ldr r1, [fp, #-20]   @ number of cards in user hand
    bl print_hand
	@ USER END DEBUG
	
	@ increment count
	add r8, r8, #1

	@ go to computer_move
	b computer_move


transfer_card_to_user:

	@ remove_card from computer
    ldr r0, [fp, #-16]   @ address of computer array
    ldr r1, [fp, #-24]   @ number of computer cards
    mov r2, r7			 @ the card   	
    bl remove_card 		

    @ add card to user
    ldr r0, [fp, #-12]   @ user hand
    mov r1, r7 			 @ the card to add
    bl add_card			 @ call add_card

	@ print the added card
	ldr r0, =card_from_computer_print
	mov r1, r7
	bl printf

    @ count pairs for user
    ldr r0, [fp, #-12]   @ address of user array
    ldr r1, [fp, #-20]   @ number of user cards
    sub r2, fp, #28      @ address of user number of pairs
    bl count_pairs

    @ USER DEBUG START player 1 header
    ldr r0, =player_1
    @branch to printf
    bl printf
    @ print player_1 hand 
    ldr r0, [fp, #-12]   @ user hand
    ldr r1, [fp, #-20]   @ number of cards in user hand
    bl print_hand
	@ USER END DEBUG

computer_move:

	@ print border
	ldr r0, =comp_print
	bl printf

	@ computer asks card
	@ computer_ask(comp_hand) returns a card
	ldr r0, [fp, #-16]   @ computer hand
	bl computer_ask_card	@ the card in r0
	
	@ save the card
	mov r7, r0

	@ check if the card is in the user hand
	@ check_card(user_hand, card) returns true(1)/false(0)
	ldr r0, [fp, #-12]   @ user hand
	mov r1, r7		@ the card -> r1
	bl check_player_card @ -> 1 or 0 in r0
	

	@ if it is -> transfer_card_to_computer
    @ if true(1):
    cmp r0, #1
    beq transfer_card_to_computer

	@ else: print go fish
	ldr r0, =go_fish_print
	bl printf

	@ else: check count_deck, if count_deck==52-> end_game
	cmp r8, #52
	bge end_game

    @ else: fish(file_ptr) -> returns a card from file
	ldr r0, [fp, #-8]			@ load the file_ptr into fish()
	bl fish					@ returns a card in r0

	@ add the card to computer
	mov r1, r0				@ move the card into r1 to pass into add_card()
    ldr r0, [fp, #-16]   @ computer hand
    bl add_card		 @ call add_card

    @ COMPUTER DEBUG START: player 2 header
    ldr r0, =player_2
    @branch to printf
    bl printf

    @ count pairs for computer
    ldr r0, [fp, #-16]   @ address of computer array
    ldr r1, [fp, #-24]   @ number of computer cards
    sub r2, fp, #32      @ address of computer number of pairs
    bl count_pairs

	@ increment count
	add r8, r8, #1

	@ go to game_loop
	b game_loop   

transfer_card_to_computer:

	@ remove the card from user
	@ remove_card(user_hand, card)
	ldr r0, [fp, #-12]   @ user hand
    mov r1, r7		@ the card   	
    bl remove_card

	@ add the card to computer
	@ add_card(computer_hand, card)
	ldr r0, [fp, #-16]   @ computer hand
    mov r1, r7 		 @ the card to add
    bl add_card		 @ call add_card

    @ COMPUTER HEADER PRINT
    ldr r0, =player_2
    @branch to printf
    bl printf

	@ count pairs for computer
	@ count_pairs(computer_hand, num_of_computer_pairs)
    ldr r0, [fp, #-16]   @ address of computer array
    ldr r1, [fp, #-24]   @ number of computer cards
    sub r2, fp, #32      @ address of computer number of pairs
    bl count_pairs

    @ COMPUTER DEBUG START: computer header
    @ldr r0, =player_2
    @branch to printf
    @bl printf
    @ print player2_hand
    @ldr r0, [fp, #-16]   @ computer hand
    @ldr r1, [fp, #-24]   @ number of cards in computer hand
    @bl print_hand
	@ COMPUTER END DEBUG.

	@ go to game_loop
	b game_loop

end_game:   

	@ compare number of pairs user vs computer
	@ more pairs -> won, == -> draw
    sub r0, fp, #28      @ address of users number of pairs
    sub r1, fp, #32      @ address of computers number of pairs
	bl print_winner

    @ load output string into r0
    ldr r0, =exiting
    @branch to printf
    bl printf

	@ close the file fclose()
	ldr r0, [fp, #-8]
	bl fclose

    @ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}
