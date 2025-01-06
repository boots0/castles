extends CanvasLayer

const PLAYER_HAND_SIZE = 9

@onready var player_hand: Node = $PlayerHand
@onready var deck_reference: Node = $Deck
@onready var pile_reference: Node = $CardPile
@onready var game_text: Node = $GameText


@export var card_scene: PackedScene

var pressed = false

func _on_deck_button_down() -> void:
	# grab the output of deck's draw_card()
	var drawn_card = deck_reference.draw_card()
	
	# connect card's reparent signal
	drawn_card.reparent_requested.connect(_on_card_reparent_requested)
	
	# add card scene as a child to player_hand
	player_hand.add_child(drawn_card)
	drawn_card.reparent(player_hand)
	
	# set card to spawn on top of the deck
	drawn_card.global_position = deck_reference.global_position - (drawn_card.card_size / 2)
	
	# add the card to the player's hand - should this happen here?
	player_hand.add_card_to_hand(drawn_card)
	drawn_card.get_node("AnimationPlayer").play("card_flip")

func _on_card_reparent_requested(card: Card, destination: Card.Destination) -> void:
	# card has signaled to be reparented

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
		player_hand.remove_card_from_hand(card)
		card.reparent(self)
		return
		

func _on_start_game_button_down() -> void:
	for i in range(PLAYER_HAND_SIZE):
		await get_tree().create_timer(0.1).timeout
		# add a deal_hand func in deck to deal face down
		var drawn_card = deck_reference.draw_card()
		# connect card's reparent signal
		drawn_card.reparent_requested.connect(_on_card_reparent_requested)
		# add card scene as a child to player_hand
		player_hand.add_child(drawn_card)
		drawn_card.get_node("AnimationPlayer").play("card_flip_start")
		# set card to spawn on top of the deck
		drawn_card.global_position = deck_reference.global_position - (drawn_card.card_size / 2)
		# add the card to the player's hand - should this happen here?
		player_hand.add_card_to_hand(drawn_card)
	game_text.text = "Please select 3 face down cards for your Castle piles"
