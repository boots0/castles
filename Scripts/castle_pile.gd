extends Node2D
class_name CastlePile

enum Status { EMPTY, HALF, FULL }

var castle_pile = []
var pile_center
var right_offset = Vector2(20, 0)
var current_status = Status.EMPTY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pile_center = self.global_position

func add_card_to_castle_pile(card: Card):
	if current_status == Status.EMPTY:
		# this is the first card, center the card on top of the pile
		card.global_position = pile_center - (card.card_size / 2)
		castle_pile.append(card)
		current_status = Status.HALF
		# disable clicking
		card.set_playable(false)
	elif current_status == Status.HALF:
		# second card played
		card.global_position = pile_center - (card.card_size / 2) + right_offset
		castle_pile.append(card)
		current_status = Status.FULL
		# disable clicking
		card.set_playable(false)
	else:
		return

func get_pile_status() -> Status:
	return current_status
