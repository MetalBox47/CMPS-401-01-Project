extends Node2D

const CardBase = preload("res://Cards/CardBase.tscn") #preloading the CardBase
const CardFocus = preload("res://Cards/CardBase.gd")
var CardSize = Vector2(125,175) #This is half the size of the card

# The PlayerDeck has to be a 2D array, [CardName, CardType]
# This is a test dummy player deck
const PlayerDeck = [["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Umbot_Lanu", "Creatures"],["Umbot_Lanu", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"]]

var CardSelected = [] # Holds an int
var DeckSize = PlayerDeck.size()

var PlayerHandSize = 0

#var windowWidth = ProjectSettings.get_setting("display/window/size/width")
#var windowHeight = ProjectSettings.get_setting("display/window/size/height")
#var window = Vector2(windowWidth, windowHeight)

var incrementer = 0
# Draws a card from the deck
func drawCard():
	if DeckSize <= 0:
		get_tree().quit()
		print("You Lose")
		return
	
	var new_card = CardBase.instance() # The CardBase node is initialized
	CardSelected = randi() % DeckSize # Assigns an random int, with respect to the DeckSize
	new_card.CardType = PlayerDeck[CardSelected][1]
	new_card.CardName = PlayerDeck[CardSelected][0]
	
	var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	new_card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y) # Assigns a global position to the card with respect to its container
	new_card.rect_scale *= CardSize/new_card.rect_size # Re-scaling to fit the playspace
	
	$Cards.add_child(new_card)
	
	PlayerDeck.erase(PlayerDeck[CardSelected])
	DeckSize -= 1
	PlayerHandSize += 1
	incrementer += 100

func playCard(card):
	$Cards.remove_child(card)
	$"VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/Left Gap".add_child(card)

func updateHand(card):
	$Cards.remove_child(card)
	var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y)
	$Cards.add_child(card)
	incrementer += 100

func _input(event):
	if Input.is_action_just_released("leftclick"):
		var cards = $Cards.get_children()
		for card in cards:
			var foundCard = false
			if foundCard:
				updateHand(card)
				continue
			if card.state == "InHand":
				playCard(card)
				incrementer -= 100
				PlayerHandSize -= 1
				foundCard = true
				card.setPlay(true)

func _ready():
	# Setting the scale of the background to fit the window
	var viewportWidth = get_viewport().size.x
	var viewportscale = viewportWidth/$DuelBackground.texture.get_size().x
	var vboxcontainerscale = viewportWidth/$VBoxContainer.rect_size.x
	$DuelBackground.set_scale(Vector2(viewportscale, viewportscale))
	$VBoxContainer.set_scale(Vector2(vboxcontainerscale, vboxcontainerscale))
	var i = 0
	while i < 7:
		drawCard()
		i += 1
