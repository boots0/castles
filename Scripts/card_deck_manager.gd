extends RefCounted
class_name CardDeckManager

const SUITS = ["blue", "orange", "purple", "red"]
const RANKS = [
	{"rank": "ace", "value": 14},
	{"rank": "two", "value": 2},
	{"rank": "three", "value": 3},
	{"rank": "four", "value": 4},
	{"rank": "five", "value": 5},
	{"rank": "six", "value": 6},
	{"rank": "seven", "value": 7},
	{"rank": "eight", "value": 8},
	{"rank": "nine", "value": 9},
	{"rank": "ten", "value": 10},
	{"rank": "jack", "value": 11},
	{"rank": "queen", "value": 12},
	{"rank": "king", "value": 13}
]

var card_scene: PackedScene = null

func initialize(card_scene: PackedScene):
	self.card_scene = card_scene

# sprite sheet properties
var sprite_origin = Vector2(0, 0)  # top-left corner of sprite sheet
var card_width = 100
var card_height = 144
var sprite_margin = Vector2(0, 0)  # space between cards

# generate all cards dynamically 
func create_deck() -> Array:
	var deck = []
	for suit in SUITS:
		for rank_data in RANKS:
			var rank = rank_data.rank
			var value = rank_data.value
			
			# calculate the sprite region
			var rank_index = RANKS.find(rank_data)
			var suit_index = SUITS.find(suit)
			
			var x = sprite_origin.x + rank_index * (card_width + sprite_margin.x)
			var y = sprite_origin.y + suit_index * (card_height + sprite_margin.y)
			var sprite_region = Rect2(Vector2(x, y), Vector2(card_width, card_height))
			# instantiate card from card scene
			var card = card_scene.instantiate() as Card
			card.initialize(suit, rank, value, sprite_region)
			deck.append(card)
	return deck
