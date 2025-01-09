extends Node2D

enum GamePhase { SETUP, PLAY, END }

var current_phase: GamePhase = GamePhase.SETUP

func update_phase(phase: GamePhase) -> void:
	current_phase = phase

func get_phase() -> GamePhase:
	return current_phase
