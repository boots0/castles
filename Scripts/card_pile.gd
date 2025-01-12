extends Node2D
class_name CardPile

@onready var pile_text = $Label

var card_pile = []
var pile_center

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pile_center = self.global_position


func add_card_to_pile(card: Card):
	# card attempted to play, emit signal to GSC to check
	
	var card_collision_shape = card.drop_point_detector.get_node("CollisionShape2D")
	if card_pile.size() > 0:
		# there are cards on the pile
		if card.value == 8:
			# card played is an 8, clear the cards from the pile and game
			clear_pile()
			pile_text.text = str(card_pile.size())
		else:
			var value_check = check_card(card)
			if value_check == true:
				# card passed check, it can be added to the pile
				card_pile.append(card)
				# center the card on top of the pile
				card.global_position = pile_center - (card.card_size / 2)
				
				# rotate the card for fun pile stacking effect
				card.pivot_offset = card.card_size / 2
				card.rotation_degrees = randf_range(-15, 15)
				
				# disable card from being clicked
				card.set_playable(false)
				
				pile_text.text = str(card_pile.size())
			else:
				# card cannot be played, send it back to hand(0)
				card.reparent_requested.emit(card, card.Destination.HAND)
				print("Card can't be played, sending back to hand")
				
	else:
		# pile is empty, play card
		# center the card on top of the pile
		card.global_position = pile_center - (card.card_size / 2)
				
		# rotate the card for fun pile stacking effect
		card.pivot_offset = card.card_size / 2
		card.rotation_degrees = randf_range(-20, 20)
		
		# disable clicking 
		card.set_playable(false)
		
		card_pile.append(card)
		pile_text.text = str(card_pile.size())

# check the last player played card vs the top card in the pile
func check_card(card: Card) -> bool:
	var last_card = card_pile.size() - 1
	return card.value >= card_pile[last_card].value or card.value == 2

# clears the card pile when 8 is played and removes cards from the game
func clear_pile():
	for child in self.get_children():
		if child is Card:
			child.queue_free()
	card_pile.clear()
