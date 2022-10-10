extends Node2D

const CardBase = preload("res://Cards/CardBase.tscn")
const CardSize = Vector2(125,175)

const PlayerDeck = [["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"], ["Umbot_Factory", "Spells"]]

var CardSelected = []
var DeckSize = PlayerDeck.size()




func _ready():
	pass
	
	
func drawCard():
	var new_card = CardBase.instance()
	CardSelected = randi() % DeckSize
	new_card.CardType = PlayerDeck[CardSelected][1]
	new_card.CardName = PlayerDeck[CardSelected][0]
	new_card.rect_position = get_global_mouse_position()
	new_card.rect_scale *= CardSize/new_card.rect_size
	$Cards.add_child(new_card)
	PlayerDeck.erase(PlayerDeck[CardSelected])
	DeckSize -= 1
	
