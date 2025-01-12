extends CanvasLayer

const PLAYER_HAND_SIZE = 9
const DECK_POSITION = Vector2(432, 102)

@onready var player_hand: Node = $PlayerHand
@onready var deck_reference: Node = $Deck
@onready var pile_reference: Node = $CardPile
@onready var game_text: Node = $GameText
@export var card_scene: PackedScene


func new_card(drawn_card: Card, animation: String) -> void:
	
	# add card scene as a child to player_hand
	player_hand.add_child(drawn_card)
	drawn_card.reparent(player_hand)
	
	# set card to spawn on top of the deck
	drawn_card.global_position = DECK_POSITION - (drawn_card.card_size / 2)
	
	# add the card to the player's hand - should this happen here?
	player_hand.add_card_to_hand(drawn_card)
	drawn_card.get_node("AnimationPlayer").play(animation)
