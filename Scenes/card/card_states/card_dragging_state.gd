extends CardState


func enter() -> void:
	print("Entered Dragging State")
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		# card picked up by player and dragging, put it in ui_layer(2)
		card.reparent_requested.emit(card, card.Destination.UI_LAYER)
	
	if not card.card_collision_shape.disabled:
		card.card_collision_shape.disabled = false


	card.scale = Vector2(1.05, 1.05)

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right click")
	var confirm = event.is_action_released("click")
	
	if mouse_motion:
		card.global_position = card.get_global_mouse_position() - card.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
		card.reparent_requested.emit(card, card.Destination.HAND)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
