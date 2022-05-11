@ Shuffles the Deck.
@ Writes to the text file random numbers from 1 to 13 four times.
@ Takes the file pointer as parameter.
@ define the architecture
.cpu cortex-a53
.fpu neon-fp-armv8

@ define constants
.data
input_shuffle: .asciz "%d\n"


@ define the shuffle_deck function
.text
.align 2
.global shuffle_deck
.type shuffle_deck, %function


shuffle_deck:

    @ save LR register
    push {fp, lr}
	add fp, sp, #4
	
	@ r0 -> file_ptr
	@ allocate memory for marker[] size of 14 to store count of each card value
	@ 1 - 13, 1 ace, ...., 13 - king
	sub sp, sp, #96					@ 14 memory locations of 4 bytes
	@ initialize it with 0s
	mov r10,#0						@ index r10 = i = 0
	
init_deck_loop:

	@ int marker[], to track number of cards of each value
	@ check if i <=14 size of marker[] array
	cmp r10, #14
	bge end_init_deck_loop
	
	@ calculate byte offset i * 4
	mov r3, r10, lsl #2
	
	@ store 0 at the marker[i] = 0
	mov r2, #0
	str r2, [sp, r3]
	
	@ increment i++
	add r10, r10, #1
	
	@ branch to the label
	b init_deck_loop
	
end_init_deck_loop:

	@ move file_ptr into r4
	mov r4, r0

	@ initialize i(counter) num_cards to generate starts with 52
	mov r10, #52 					@ i = 52
	
shuffle_deck_loop:

	@ check if i <=0
	cmp r10, #0
	ble end_shuffle_deck_loop

	@ else: generate random card number
	bl rand
	mov r1, #13
	@ call mod(rand(), 13) to return number from 0 to 12
	bl mod
	@ add to the returned number from mod 1 to get number from 1 to 13
	@ r0 = rand_card
	add r0, r0, #1
 
	@ calculate offset marker[rand%13 +1]
	mov r5, r0, lsl #2
	
	@ r3 = marker[rand%13 +1]
	ldr r3, [sp, r5]
	
	@ check marker if marker[card] >= 4, max = 4 of numbers for each value of card
	cmp r3, #4
	bge skip_card 					@ if there are already 4 cards with the same value
	
	@ update marker[] to include the new card
	add r3, r3, #1		@ increment the number of cards of the same value r3++ 
	@ store it back in memory to update the count
	str r3,  [sp, r5]
	
	@ else: decrement num_cards--
	sub r10, r10, #1
	
	@ write the card to the file fprintf(file_ptr, "%d\n", rand_card)
	@ move rand_card into r2 (dealt a valid card)
	mov r2, r0
	@ load input format
	ldr r1, =input_shuffle
	@ move file_ptr into r0
	mov r0, r4
	@ fprintf(file_ptr, "%d", rand_card)
	bl fprintf						@ write to the deck_file the rand_card number
	
skip_card:

	b shuffle_deck_loop
	
end_shuffle_deck_loop:

    @ restore fp, lr registers
    sub sp, fp, #4
    pop {fp, pc}


