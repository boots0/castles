extends Control
class_name Game

enum GamePhase { SETUP, PLAY, END }

@onready var game_state_controller: Control = $GameStateController

var current_phase: GamePhase = GamePhase.SETUP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_state_controller.connect("trigger_phase_check", _on_phase_check)
	game_state_controller.connect("request_phase_change", _on_phase_change_request)


func _on_phase_check() -> GamePhase:
	return current_phase

func _on_phase_change_request(from, to):
	#check phase
	current_phase = to
