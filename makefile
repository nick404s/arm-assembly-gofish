go_fish: main.o shuffle_deck.o deal_cards.o print_hand.o count_pairs.o mod.o ask_card.o check_player_card.o remove_card.o init_array.o add_card.o fish.o computer_ask_card.o print_winner.o   
	gcc -o go_fish main.o shuffle_deck.o deal_cards.o print_hand.o count_pairs.o mod.o ask_card.o check_player_card.o remove_card.o init_array.o add_card.o fish.o computer_ask_card.o print_winner.o

main.o: main.s
	gcc -c -g main.s

mod.o: mod.s
	gcc -c -g mod.s

shuffle_deck.o: shuffle_deck.s
	gcc -c -g shuffle_deck.s

deal_cards.o: deal_cards.s
	gcc -c -g deal_cards.s

print_hand.o: print_hand.s
	gcc -c -g print_hand.s

count_pairs.o: count_pairs.s
	gcc -c -g count_pairs.s

ask_card.o: ask_card.s
	gcc -c -g ask_card.s

check_player_card.o: check_player_card.s
	gcc -c -g check_player_card.s

remove_card.o: remove_card.s
	gcc -c -g remove_card.s

init_array.o: init_array.s
	gcc -c -g init_array.s

add_card.o: add_card.s
	gcc -c -g add_card.s

fish.o: fish.s
	gcc -c -g fish.s

computer_ask_card.o: computer_ask_card.s
	gcc -c -g computer_ask_card.s

print_winner.o: print_winner.s
	gcc -c -g print_winner.s

clean:
	rm *.o
