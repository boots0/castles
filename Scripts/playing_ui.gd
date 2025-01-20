extends Control
class_name PlayerUI

const PLAYER_HAND_SIZE = 9
const DECK_POSITION = Vector2(697, 405)

@onready var player_hand: Node = $PlayerHand
@export var card_scene: PackedScene


func add_card(drawn_card: Card, animation: String) -> void:
	# set card to spawn on top of the deck
	drawn_card.global_position = DECK_POSITION - (drawn_card.card_size / 2)
	
	# add the card to the player's hand - should this happen here?
	player_hand.add_card_to_hand(drawn_card)
	drawn_card.get_node("AnimationPlayer").play(animation)
