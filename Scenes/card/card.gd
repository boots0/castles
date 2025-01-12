extends Control
class_name Card

# Goal: do not handle card logic in the card, allow the CardManager to do this
signal reparent_requested(which_card_ui: Card, where: Destination) # 0 = hand, 1 = pile, 2 = ui_layer

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_image: Sprite2D = $CardFront
@onready var targets: Array[Node] = []

enum Destination {HAND, PILE, UI_LAYER}


var suit: String
var rank: String
var value: int
var sprite_region: Rect2  # stores card's sprite region
var card_size
var input_enabled

func initialize(suit, rank, value, sprite_region):
	self.suit = suit
	self.rank = rank
	self.value = value
	self.sprite_region = sprite_region
	self.input_enabled = true
	
	# Set up front and back images
	var card_image = get_node("CardFront")
	card_image.region_rect = sprite_region
	card_image.visible = false  # Hidden initially
	
	card_size = self.get_rect().size

func _ready() -> void:
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	if not input_enabled:
		return
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	if not input_enabled:
		return
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	if not input_enabled:
		return
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	if not input_enabled:
		return
	card_state_machine.on_mouse_exited()
	

# these drop point detectors help determine if the card is hovering over the pile
func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func set_playable(status: bool):
	self.input_enabled = status

func reveal():
	card_image.visible = true  # Show the card front
