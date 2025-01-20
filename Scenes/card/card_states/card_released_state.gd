extends CardState



func enter() -> void:
	pass
func on_input(_event: InputEvent) -> void:
	if card.targets:
		# card was played in a target area (pile), emit reparent signal to PILE
		card.reparent_requested.emit(card, card.Destination.PILE)
		# change card State
		transition_requested.emit(self, CardState.State.BASE)
		return
	# card was not played on a pile, emit reparent signal to HAND
	card.reparent_requested.emit(card, card.Destination.HAND)
	transition_requested.emit(self, CardState.State.BASE)
