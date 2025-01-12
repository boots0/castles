extends Node2D

const PLAYER_HAND_SIZE = 9

enum GamePhase { SETUP, PLAY, END }

@onready var player_hand: Node = $PlayerHand
@onready var deck_reference: Node = $Deck
@onready var pile_reference: Node = $CardPile
@onready var game_text: Node = $GameText
@onready var player_ui = $PlayingUI

var current_phase: GamePhase = GamePhase.SETUP

func _on_deck_button_down() -> void:
	if current_phase == GamePhase.PLAY:
		player_ui.deal_card_to_player()


func _on_start_game_button_down() -> void:
		#var current_phase = get_parent().get_phase()
	if current_phase == GamePhase.SETUP:
		for i in range(PLAYER_HAND_SIZE):
			await get_tree().create_timer(0.1).timeout
			# add a deal_hand func in deck to deal face down
			var drawn_card = deck_reference.draw_card()
			# connect card's reparent signal
			drawn_card.reparent_requested.connect(_on_card_reparent_requested)
			deal_card(drawn_card)
		
	update_game_text("Please select 3 face down cards for your Castle piles")

func update_game_text(text: String):
	game_text.text = text

func deal_card(card: Card, player = player_ui):
	if current_phase == GamePhase.SETUP:
		player.new_card(card, "card_flip_start")

func _on_card_reparent_requested(card: Card, destination: Card.Destination) -> void:
	# card has signaled to be reparented
	# ** all of this needs to be refactored **
	if destination == card.Destination.HAND:
		print("Reparenting to hand...")
		card.reparent(player_hand)
		player_hand.add_card_to_hand(card) # 1 = game ongoing
		return
		
	if destination == card.Destination.PILE:
		print("Reparenting to a pile...")
		player_hand.remove_card_from_hand(card)
		
		var target_pile = card.targets[0].get_parent()
		if target_pile is CardPile:
			card.reparent(pile_reference)
			pile_reference.add_card_to_pile(card)
		else:
			card.reparent(target_pile)
			target_pile.add_card_to_pile(card)
		return
		
	if destination == card.Destination.UI_LAYER:
		print("Reparenting to UI Layer")
		#player_hand.remove_card_from_hand(card)
		card.reparent(player_ui)
		return
		
