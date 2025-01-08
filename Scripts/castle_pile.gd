extends Node2D

var castle_pile = []
var pile_center
var right_offset = Vector2(20, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pile_center = self.global_position


func add_card_to_pile(card: Card):
	if castle_pile.size() < 2:
		# pile max not reached
		if castle_pile.size() == 0:
			# this is the first card
			# center the card on top of the pile
			card.global_position = pile_center - (card.card_size / 2)
			castle_pile.append(card)
			
			# disable clicking
			card.set_playable(false)
		else:
			# second card
			card.global_position = pile_center - (card.card_size / 2) + right_offset
			castle_pile.append(card)
			# disable clicking
			card.set_playable(false)
	else:
		# castle pile max reached, reparent
		card.reparent_requested.emit(card, card.Destination.HAND)
