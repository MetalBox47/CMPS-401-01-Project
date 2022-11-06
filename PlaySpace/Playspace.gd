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
var fieldIncrementer = 0
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
	
	var fieldSpot = get_node("VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/Left Gap")
	var CardPos_x = fieldSpot.rect_global_position.x
	var CardPos_y = fieldSpot.rect_global_position.y
	card.rect_position = Vector2(CardPos_x+fieldIncrementer, CardPos_y)
	card.rect_scale *= CardSize/card.rect_size
	
	$PlayerField.add_child(card)
	card.state = "OutHand"
	card.setPlay(true)
	
	fieldIncrementer += 180

func updateHand():
	incrementer = 0
	var cards = $Cards.get_children()
	for card in cards:
		var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
		var CardPos_x = PlayerDeckNode.rect_global_position.x
		var CardPos_y = PlayerDeckNode.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y)
		incrementer += 100

func killCard(card):
	$PlayerField.remove_child(card)
	
	var graveyard = get_node("Graveyard/HBoxContainer")
	var CardPos_x = graveyard.rect_global_position.x
	var CardPos_y = graveyard.rect_global_position.y
	card.rect_position = Vector2(CardPos_x, CardPos_y)
	card.rect_scale *= CardSize/card.rect_size
	
	$Graveyard.add_child(card)

func updateField():
	fieldIncrementer = 0
	var field = $PlayerField.get_children()
	for card in field:
		var PlayerFieldNode = get_node("VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/Left Gap")
		var CardPos_x = PlayerFieldNode.rect_global_position.x
		var CardPos_y = PlayerFieldNode.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+fieldIncrementer, CardPos_y)
		fieldIncrementer += 180

func _input(event):
	var playing = false
	if Input.is_action_just_released("leftclick"):
		var cards = $Cards.get_children()
		for card in cards:
			if card.state == "InHand":
				playing = true
				playCard(card)
				PlayerHandSize -= 1
				updateHand()
		
		if !playing:
			var field = $PlayerField.get_children()
			for card in field:
				if card.state == "InHand":
					killCard(card)
					updateField()

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
