extends Node2D

@onready var player_hand: Node = $"../PlayingUI/PlayerHand"
@onready var deck_reference: Node = $"../Deck"

@export var card_scene: PackedScene

var pressed = false
var card_drawn

## deck clicked
#func _on_deck_button_down() -> void:
	#card_drawn = deck_reference.draw_card()
	#player_hand.add_card_to_hand(card_drawn)
