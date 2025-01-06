extends Node
class_name CardState

enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

signal transition_requested(from: CardState, to: State)

@export var state: State

var card: Card
var where_i_am_from: State # could I use something like this to keep a history of the previous state?

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

func on_mouse_enetered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
