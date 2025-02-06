extends Button
class_name Deck

signal _on_card_drawn(card: Card)

const CARD_SCENE_PATH = "res://card.tscn" # path to card scene
const CARD_DRAW_SPEED = 0.2

@export var card_scene: PackedScene

var card_deck_manager = CardDeckManager.new()
var player_deck = []

 # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if card_scene == null:
		push_error("Card scene is not set")
		return
	# generate deck
	card_deck_manager.initialize(card_scene) as Card
	player_deck = card_deck_manager.create_deck()
	player_deck.shuffle()
	print("Deck created and shuffled: ")

func draw_card() -> Card:
	if player_deck.size() == 0:
		# Deck is empty, disable drawing
		$".".disabled = true
		$Sprite2D.visible = false
		return
	
	# pop card from the deck
	var card_drawn = player_deck.pop_front()
	
	# instantiate new card
	# player hand should listen for this and take a card. not the deck adding the child to the playerhand
	var new_card = card_scene.instantiate()
	new_card.initialize(card_drawn.suit, card_drawn.rank, card_drawn.value, card_drawn.sprite_region)
	
	#new_card.position = self.position # spawn at deck
	new_card.name = card_drawn.suit + " " + card_drawn.rank
	#new_card.position = self.global_position
	
	return new_card
	
