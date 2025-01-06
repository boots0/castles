extends CardState

func enter() -> void:
	print("Entering base state...")
	if not card.is_node_ready():
		await card.ready
	
	## this is for the first time the card is dealt
	#if card.played == false:
		## card dealt or released on table, put it in hand(0)
		#card.reparent_requested.emit(card, 0)
	card.pivot_offset = Vector2.ZERO
	card.scale = Vector2(1, 1)

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
