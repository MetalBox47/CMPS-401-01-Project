extends Node2D

const CardBase = preload("res://Cards/CardBase.tscn") #preloading the CardBase
const CardSize = Vector2(125,175) #This is half the size of the card

# The PlayerDeck has to be a 2D array, [CardName, CardType]
const PlayerDeck = [["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"], ["Umbot_Factory", "Spells"]]

var CardSelected = [] # Holds an int
var DeckSize = PlayerDeck.size()


var windowWidth = ProjectSettings.get_setting("display/window/size/width")
var windowHeight = ProjectSettings.get_setting("display/window/size/height")




var window = Vector2(windowWidth, windowHeight)
 


func _ready():
	#OS.window_fullscreen = !OS.window_fullscreen
	# Setting the scale of the background to the window
	var viewportWidth = get_viewport().size.x
	var viewportscale = viewportWidth/$DuelBackground.texture.get_size().x
	$DuelBackground.set_scale(Vector2(viewportscale, viewportscale))
	#$DuelBackground.scale *= get_viewport_rect().size/$DuelBackground.texture.get_size()
	#$DuelBackground.scale *= window/$DuelBackground.texture.get_size()
	#$DrawDeck.scale *= $DuelBackground.scale
	pass



# Draws a card from the deck
func drawCard():
	
	var new_card = CardBase.instance() # The CardBase node is initialized
	CardSelected = randi() % DeckSize # Assigns an random int, with respect to the DeckSize
	new_card.CardType = PlayerDeck[CardSelected][1]
	new_card.CardName = PlayerDeck[CardSelected][0]
	new_card.rect_position = Vector2(windowWidth/3, windowHeight/2)
	new_card.rect_scale *= CardSize/new_card.rect_size
	$Cards.add_child(new_card)
	PlayerDeck.erase(PlayerDeck[CardSelected])
	DeckSize -= 1
	windowWidth += 100
	print(windowWidth, ", ", windowHeight)
func drawCards():
	var new_cards = []
	for card in range(DeckSize):
		drawCard()
