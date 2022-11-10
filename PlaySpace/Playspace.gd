extends Node2D

enum CardPopupId {
	PLAY
	ATTACK
	KILL
	ADDTOHAND
	SHUFFLE
}

const CardBase = preload("res://Cards/CardBase.tscn") #preloading the CardBase
const CardFocus = preload("res://Cards/CardBase.gd")
var CardSize = Vector2(125,175) #This is half the size of the card

# The PlayerDeck has to be a 2D array, [CardName, CardType]
# This is a test dummy player deck
const PlayerDeck = [["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Umbot_Lanu", "Creatures"],["Umbot_Lanu", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"]]

var GraveArr = []

onready var pm = $PopupMenu

var CardSelected = [] # Holds an int
var DeckSize = PlayerDeck.size()

var PlayerHandSize = 0

var cardCounters = []

var PlayerHealth
var OpponentHealth

var phase
var cards_playable = false
var battling = false

var selected_card

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
	new_card.CardType = PlayerDeck[0][1]
	new_card.CardName = PlayerDeck[0][0]
	
	var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	new_card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y) # Assigns a global position to the card with respect to its container
	new_card.rect_scale *= CardSize/new_card.rect_size # Re-scaling to fit the playspace
	
	$Cards.add_child(new_card)
	
	PlayerDeck.remove(0)
	DeckSize -= 1
	PlayerHandSize += 1
	incrementer += 100

func mill():
	if DeckSize <= 0:
		return
	
	var new_card = CardBase.instance() # The CardBase node is initialized
	new_card.CardType = PlayerDeck[0][1]
	new_card.CardName = PlayerDeck[0][0]
	
	var PlayerDeckNode = get_node("Graveyard/HBoxContainer")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	new_card.rect_position = Vector2(CardPos_x, CardPos_y) # Assigns a global position to the card with respect to its container
	new_card.rect_scale *= CardSize/new_card.rect_size # Re-scaling to fit the playspace
	
	$Graveyard.add_child(new_card)
	
	PlayerDeck.remove(0)

func shuffle_card(card):
	var parent = card.get_parent()
	parent.remove_child(card)
	if parent == $Cards:
		updateHand()
	elif parent == $PlayerField:
		updateField()
	PlayerDeck.append([card.CardName, card.CardType])
	DeckSize += 1
	PlayerDeck.shuffle()

func playCard(card):
	$Cards.remove_child(card)
	updateHand()
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
	updateHand()

func return_card_to_hand(card):
	var parent = card.get_parent()
	parent.remove_child(card)
	if parent == $PlayerField:
		updateField()
	var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y) # Assigns a global position to the card with respect to its container
	card.rect_scale *= CardSize/card.rect_size # Re-scaling to fit the playspace
	$Cards.add_child(card)
	PlayerHandSize += 1
	incrementer += 100

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
	if card.get_parent() == $Cards:
		$Cards.remove_child(card)
		var graveyard = get_node("Graveyard/HBoxContainer")
		var CardPos_x = graveyard.rect_global_position.x
		var CardPos_y = graveyard.rect_global_position.y
		card.rect_position = Vector2(CardPos_x, CardPos_y)
		card.rect_scale *= CardSize/card.rect_size
		$Graveyard.add_child(card)
	elif card.get_parent() == $PlayerField:
		$PlayerField.remove_child(card)
		var graveyard = get_node("Graveyard/HBoxContainer")
		var CardPos_x = graveyard.rect_global_position.x
		var CardPos_y = graveyard.rect_global_position.y
		card.rect_position = Vector2(CardPos_x, CardPos_y)
		card.rect_scale *= CardSize/card.rect_size
		$Graveyard.add_child(card)
		updateField()

func updateField():
	fieldIncrementer = 0
	var field = $PlayerField.get_children()
	for card in field:
		var PlayerFieldNode = get_node("VBoxContainer/Player1Side/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer")
		var CardPos_x = PlayerFieldNode.rect_global_position.x
		var CardPos_y = PlayerFieldNode.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+fieldIncrementer, CardPos_y)
		fieldIncrementer += 180

func hand_pop():
	if phase == 1:
		pm.clear()
		pm.add_item("Play", CardPopupId.PLAY)
		pm.add_item("Discard", CardPopupId.KILL)
		pm.add_item("Shuffle", CardPopupId.SHUFFLE)
	else:
		pm.clear()

func field_pop():
	match phase:
		0:
			pm.clear()
		1:
			pm.clear()
			pm.add_item("Kill", CardPopupId.KILL)
			pm.add_item("Return to Hand", CardPopupId.ADDTOHAND)
			pm.add_item("Shuffle", CardPopupId.SHUFFLE)
		2:
			pm.clear()
			pm.add_item("Attack", CardPopupId.ATTACK)
			pm.add_item("Kill", CardPopupId.KILL)
			pm.add_item("Return to Hand", CardPopupId.ADDTOHAND)
		3:
			pm.clear()

func _input(event):
	var playing = false
	if Input.is_action_just_released("leftclick"):
		var cards = $Cards.get_children()
		for card in cards:
			if card.state == "InHand":
				selected_card = card
				pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
				hand_pop()
				playing = true
		
		if !playing:
			var field = $PlayerField.get_children()
			for card in field:
				if card.state == "InHand":
					selected_card = card
					pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
					field_pop()
	
	if Input.is_action_just_pressed("Change Phase"):
		if phase == 1:
			phase = 2
			process_phases()
		elif phase == 2:
			phase = 3
			process_phases()

func _on_PopupMenu_id_pressed(id):
	match id:
		CardPopupId.PLAY:
			playCard(selected_card)
		CardPopupId.KILL:
			killCard(selected_card)
		CardPopupId.SHUFFLE:
			shuffle_card(selected_card)
		CardPopupId.ADDTOHAND:
			return_card_to_hand(selected_card)
		CardPopupId.ATTACK:
			pass

func _on_PopupMenu_index_pressed(index):
	pass

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
	pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	pm.connect("index_pressed", self, "_on_PopupMenu_index_pressed")
	PlayerDeck.shuffle()
	var i = 0
	while i < 7:
		drawCard()
		i += 1
	PlayerHealth = 40
	OpponentHealth = 40
	phase = 0
	process_phases()
