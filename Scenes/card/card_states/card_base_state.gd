extends CardState

func enter() -> void:
	print("Entering base state...")
	if not card.is_node_ready():
		await card.ready
	
	card.pivot_offset = Vector2.ZERO

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
