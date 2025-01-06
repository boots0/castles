extends CardState

func enter() -> void:
	card.scale = Vector2(1.55, 1.55)
	card.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
