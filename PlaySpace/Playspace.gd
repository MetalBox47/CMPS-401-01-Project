extends Node2D

enum CardOptions {
	PLAY
	BATTLE
	SENDTOGY
}

enum DeckOptions {
	DRAW
	MILL
	FORFEIT
}

const CardBase = preload("res://Cards/CardBase.tscn") #preloading the CardBase
const CardFocus = preload("res://Cards/CardBase.gd")
var CardSize = Vector2(125,175) #This is half the size of the card

# The PlayerDeck has to be a 2D array, [CardName, CardType]
# This is a test dummy player deck
const PlayerDeck = [["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Umbot_Lanu", "Creatures"],["Umbot_Lanu", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"]]

var CardSelected = [] # Holds an int
var DeckSize = PlayerDeck.size()

var PlayerHandSize = 0

var cardCounters = []

var PlayerHealth
var OpponentHealth

var phase
var cards_playable = false
var battling = false

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
	
	var playedPos
	var duplicate = false
	var in_stack = false
	var storedName = ''
	var cardNum = 0
	for playedCard in $PlayerField.get_children():
		if in_stack and playedCard.CardName == storedName:
			playedPos = playedCard.rect_position
			continue
		elif !in_stack and playedCard.CardName == storedName:
			continue
		
		if card.CardName == playedCard.CardName:
			duplicate = true
			in_stack = true
			storedName = playedCard.CardName
			playedPos = playedCard.rect_position
		else:
			storedName = playedCard.CardName
			cardNum += 1
	
	if !duplicate:
		var fieldSpot = get_node("VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer")
		var CardPos_x = fieldSpot.rect_global_position.x
		var CardPos_y = fieldSpot.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+fieldIncrementer, CardPos_y)
		card.rect_scale *= CardSize/card.rect_size
		cardCounters.append(1)
		fieldIncrementer += 180
	else:
		card.rect_scale *= CardSize/card.rect_size
		cardCounters[cardNum] += 1
		card.rect_position = Vector2(playedPos.x + (cardCounters[cardNum] * 10), playedPos.y)
	
	$PlayerField.add_child(card)
	card.state = "OutHand"
	card.setPlay(true)

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
		var PlayerFieldNode = get_node("VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer")
		var CardPos_x = PlayerFieldNode.rect_global_position.x
		var CardPos_y = PlayerFieldNode.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+fieldIncrementer, CardPos_y)
		fieldIncrementer += 180

func _input(event):
	var playing = false
	if Input.is_action_just_released("leftclick") and cards_playable:
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
	
	if Input.is_action_just_pressed("Change Phase"):
		if phase == 1:
			phase = 2
			process_phases()
		elif phase == 2:
			phase = 3
			process_phases()

func process_phases():
	match(phase):
		0:
			print("Draw Phase")
			cards_playable = false
			battling = false
			drawCard()
			phase = 1
			process_phases()
		1:
			print("Main Phase")
			cards_playable = true
			battling = false
		2:
			print("Battle Phase")
			cards_playable = false
			battling = true
		3:
			print("End Phase")
			cards_playable = false
			battling = false
			get_tree().quit()

func _process(delta):
	if PlayerHealth <= 0:
		print("You Lose!")
	if OpponentHealth <= 0:
		print("You Win!")

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
	PlayerHealth = 40
	OpponentHealth = 40
	phase = 0
	process_phases()
