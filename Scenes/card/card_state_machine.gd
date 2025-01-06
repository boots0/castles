extends Node
class_name CardStateMachine

@export var initial_state: CardState  # set starting state, BASE

var current_state: CardState  # stores current state card is in
var states := {}  # stores all states available in the state machine

func init(card: Card) -> void:
	# go through all children in state machine
	for child in get_children():
		# check if child is a CardState
		if child is CardState:
			# child is a CardState, add it to states Dictionary
			states[child.state] = child
			# connect transition signal to CSM's transition func where transition is handled
			child.transition_requested.connect(_on_transition_requested)
			# pass card reference to the state itself
			child.card = card
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)

func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_enetered()

func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from != current_state:
		return
	
	var new_state: CardState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
