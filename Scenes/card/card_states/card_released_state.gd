extends CardState



func enter() -> void:
	card.scale = Vector2(1, 1)
	
	if not card.targets.is_empty():
		# card is over card pile
		# needs target.reparent - line 17
		card.played = true

func on_input(_event: InputEvent) -> void:
	if card.played:
		# card was played, put it on pile(1)
		print("leaving released")
		card.reparent_requested.emit(card, card.Destination.PILE)
		transition_requested.emit(self, CardState.State.BASE)
		return
	# card was not played, transition to BASE
	card.reparent_requested.emit(card, card.Destination.HAND)
	transition_requested.emit(self, CardState.State.BASE)
