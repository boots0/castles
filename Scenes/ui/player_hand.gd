extends Node2D
class_name PlayerHand

signal card_removed(hand_count: int)
# exported variables
@export var card_width: float = 30.0
@export var hand_y_position: float = 500.0
@export var default_card_move_speed: float = 0.25

@onready var deck_reference: Node = $"../../Deck"

var player_hand = [] # holds cards for the player's hand
var center_screen_x  # holds the centerpoint of the screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set position of the hand at center screen
	var viewport_size = get_viewport().get_visible_rect().size
	center_screen_x = viewport_size.x / 2
	position = Vector2(center_screen_x, hand_y_position)


# === CARD HANDLING === 
# phase is 0 (game start) or 1 (game ongoing)
func add_card_to_hand(card: Card, speed: float = default_card_move_speed) -> void:
		if card not in player_hand:
			# card isn't in hand, put it there
			player_hand.append(card)
			update_hand_positions(default_card_move_speed)

func remove_card_from_hand(card: Card) -> void:
	if card in player_hand:
		# card is in player hand. erase card and update hand positions
		player_hand.erase(card)
		update_hand_positions()
		emit_signal("card_removed", player_hand.size())

func update_hand_positions(speed: float = default_card_move_speed) -> void:
	for i in range(player_hand.size()):
		# get new card position based on index
		var new_position = Vector2(calculate_card_position(i), hand_y_position)
		animate_card_to_position(player_hand[i], new_position, speed)


func calculate_card_position(index: int) -> float:
	var total_width = (player_hand.size() - 1) * card_width
	var x_offset = center_screen_x + index * card_width - total_width / 2 
	return x_offset

func animate_card_to_position(card: Card, new_position: Vector2, speed: float) -> void:
	# tweens are used for lightweight animations
	var tween = get_tree().create_tween()
	# .tween_property(object we want moved, property being changed, the change, speed)
	tween.tween_property(card, "global_position", new_position, speed)

# after player selects 3 face down cards to play, reveal all cards
func flip_cards():
	# Loop through children 
	for child in get_children():
		if child is Card:
			# child is card, flip it over
			child.get_node("AnimationPlayer").play("card_turn")
			child.reveal()
