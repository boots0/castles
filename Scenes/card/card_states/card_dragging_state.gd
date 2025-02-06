extends CardState


func enter() -> void:
	print("Entered Dragging State")
	card.z_index = 1

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right click")
	var confirm = event.is_action_released("click")
	
	if mouse_motion:
		card.global_position = card.get_global_mouse_position() - card.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
		#card.reparent_requested.emit(card, card.Destination.HAND)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
