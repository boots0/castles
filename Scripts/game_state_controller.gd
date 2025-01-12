extends Node2D

const PLAYER_HAND_SIZE = 9

enum GamePhase { SETUP, PLAY, END }

@onready var player_hand: Node = $PlayingUI/PlayerHand
@onready var piles: Node2D = $PlayingUI/Piles
@onready var deck_reference: Node = $Deck
@onready var pile_reference: Node = $CardPile
@onready var game_text: Node = $GameText
@onready var player_ui = $PlayingUI

var current_phase: GamePhase = GamePhase.SETUP

func _ready() -> void:
	player_hand.connect("card_removed", _on_game_setup)

func _on_deck_button_down() -> void:
	if current_phase == GamePhase.PLAY:
		var drawn_card = deck_reference.draw_card()
		# connect card's reparent signal
		drawn_card.reparent_requested.connect(_on_card_reparent_requested)
		deal_card(drawn_card)


func _on_start_game_button_down() -> void:
		#var current_phase = get_parent().get_phase()
	if current_phase == GamePhase.SETUP:
		update_game_text("Please select 3 face down cards for your Castle piles")
		for i in range(PLAYER_HAND_SIZE):
			await get_tree().create_timer(0.1).timeout
			# add a deal_hand func in deck to deal face down
			var drawn_card = deck_reference.draw_card()
			# connect card's reparent signal
			drawn_card.reparent_requested.connect(_on_card_reparent_requested)
			deal_card(drawn_card)
		

func deal_card(card: Card, player = player_ui):
	if current_phase == GamePhase.SETUP:
		player.new_card(card, "card_flip_start")
	if current_phase == GamePhase.PLAY:
		player.new_card(card, "card_flip")

func _on_card_reparent_requested(card: Card, destination: Card.Destination) -> void:
	# card has signaled to be reparented
	if destination == card.Destination.HAND:
		# send card to hand
		card.reparent(player_hand)
		player_hand.add_card_to_hand(card)
		return
		
	if destination == card.Destination.PILE:
		# card was placed on a pile, remove from hand for now
		#player_hand.remove_card_from_hand(card)
		# get which pile was card played on
		var target_pile = card.targets[0].get_parent()
		
		if target_pile is CardPile:
			print("Adding card to shared card pile")
			# card has been played on shared CardPile, check phase
			if current_phase == GamePhase.PLAY:
				# game is in PLAY, put card on pile
				card.reparent(pile_reference)
				pile_reference.add_card_to_pile(card)
				player_hand.remove_card_from_hand(card)
			elif GamePhase.SETUP:
				print("Card not allowed, we are in SETUP")
				# game is in SETUP, cannot play on CardPile, send to hand
				card.reparent(player_hand)
			else:
				print("We shouldn't be here - line 60 game_state_controller.gd")
				return
				
		else:
			# card was played on CastlePile
			
			if current_phase == GamePhase.SETUP:
				# game is in SETUP, check CastlePile status
				var status = target_pile.get_pile_status()
				
				if status == target_pile.Status.EMPTY:
					# CastlePile is EMPTY in SETUP, play the card on it
					card.reparent(target_pile)
					target_pile.add_card_to_castle_pile(card)
					player_hand.remove_card_from_hand(card)
					
				if status == target_pile.Status.HALF:
					# CastlePile has 1 card on it, check other piles first before playing
					var pile_statuses = get_castle_piles_status(target_pile)
					
					if CastlePile.Status.EMPTY in pile_statuses.values():
						# 1 or more pile is empty, can't play a second card on the pile yet
						card.reparent(player_hand)
						player_hand.add_card_to_hand(card)
					else:
						# all piles have 1 card on them, play second card
						card.reparent(target_pile)
						target_pile.add_card_to_castle_pile(card)
						player_hand.remove_card_from_hand(card)
						
					# check if this was the last pile
					var full_pile_count = count_full_piles(pile_statuses)
					if full_pile_count == 2:
						set_game_phase(GamePhase.PLAY)
						
				if status == target_pile.Status.FULL:
					# CastlePile is FULL, send to hand
					card.reparent(player_hand)
					player_hand.add_card_to_hand(card)
			else:
				# we are not in SETUP, card goes back to hand
				card.reparent(player_hand)
				player_hand.add_card_to_hand(card)
		return
		
	if destination == card.Destination.UI_LAYER:
		card.reparent(player_ui)
		return

func get_castle_piles_status(target_pile: CastlePile) -> Dictionary:
	# needs to pass info about pile sizes idk what yet
	var pile_statuses = {}
	
	for pile in piles.get_children():
		if pile is CastlePile:
			var status = pile.get_pile_status()
			pile_statuses[pile.name] = status
	
	# erase target_pile from dictionary
	pile_statuses.erase(target_pile.name)
	return pile_statuses

func count_full_piles(pile_statuses: Dictionary) -> int:
	var count = 0
	for status in pile_statuses.values():
		if status == CastlePile.Status.FULL:
			count += 1
			
	return count

func _on_game_setup(hand_count: int):
		if current_phase == GamePhase.SETUP:
			if hand_count == 6:
				player_hand.flip_cards()
			if hand_count == 3:
				update_game_text("Game is now in PLAY")
				
func set_game_phase(phase: GamePhase):
	current_phase = phase

func update_game_text(text: String):
	game_text.text = text
