extends PlayerUI
class_name PlayerHand

signal card_removed(hand_count: int)

const HAND_WIDTH: float  = 100
const HAND_BUFFER: float = 100
# exported variables
@export var card_width: float = 100.0
@export var default_card_move_speed: float = 0.25

@export var max_stack_size : int = -1
@export var x_spread : float = 0
@export var y_spread : float = 0

@export var hand_spread_curve : Curve 
@export var hand_height_curve : Curve 
@export var hand_rotation_curve : Curve 

@onready var cards_node: Node2D = $Cards
@onready var color_rect: ColorRect = $ColorRect


var hand = [] # holds cards for the player's hand
var hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_position = global_position
	## set position of the hand at center screen
	#var viewport_size = get_viewport().get_visible_rect().size
	#hand_midpoint = viewport_size.x / 2
	#position = Vector2(center_screen_x, self.position.y)


# === CARD HANDLING === 
# phase is 0 (game start) or 1 (game ongoing)
func add_card_to_hand(card: Card, speed: float = default_card_move_speed) -> void:
		if card not in hand:
			print("=== Adding ", card.name, " ===")
			# card isn't in hand, put it there
			hand.append(card)
			update_hand_positions(default_card_move_speed)
			card.reparent(cards_node)
		else:
			update_hand_positions(default_card_move_speed)
			card.reparent(cards_node)

func remove_card_from_hand(card: Card) -> void:
	if card in cards_node.get_children():
		# card is in player hand. erase card and update hand positions
		hand.erase(card)
		update_hand_positions()
		emit_signal("card_removed", hand.size())

func update_hand_positions(speed: float = default_card_move_speed) -> void:
	#for i in range(hand.size()):
		## get new card position based on index
		#var new_position = Vector2(calculate_card_position(i), self.position.y)
		#animate_card_to_position(hand[i], new_position, speed)
	for card in cards_node.get_children():
		var hand_ratio = 0.5 # for first card in hand
		if cards_node.get_child_count() > 1:
			# more than 1 card in hand
			hand_ratio = float(card.get_index() / float(cards_node.get_child_count() - 1))
		print(card.name, " hand_ratio: ", hand_ratio)
		var destination = hand_position
		destination.x += HAND_BUFFER + hand_spread_curve.sample_baked(hand_ratio) * HAND_WIDTH
		print(card.name, " destination: ", destination)
		animate_card_to_position(card, destination, default_card_move_speed)

#func calculate_card_position(index: int) -> float:
	#var total_width = (hand.size() - 1) * card_width
	#var x_offset = center_screen_x + index * card_width - total_width / 2 
	#return x_offset

func animate_card_to_position(card: Card, new_position: Vector2, speed: float) -> void:
	# tweens are used for lightweight animations
	var tween = get_tree().create_tween()
	# .tween_property(object we want moved, property being changed, the change, speed)
	tween.tween_property(card, "global_position", new_position, speed)

# after player selects 3 face down cards to play, reveal all cards
func flip_cards():
	# Loop through children 
	for child in cards_node.get_children():
		if child is Card:
			# child is card, flip it over
			child.get_node("AnimationPlayer").play("card_turn")
			child.reveal()
