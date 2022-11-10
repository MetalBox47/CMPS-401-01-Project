extends Node2D

enum PopupId {
	PLAY
	ATTACK
	KILL
	ADDTOHAND
	SHUFFLE
	DRAW
	MILL
	VIEWDECK
	SHUFFLEDECK
	FORFEIT
	VIEWGRAVE
}

#onready var deck_node = get_node("/root/DeckBuilder/DeckBuilder")

const main_icon = preload("res://Asset/Main_Phase_Icon.png")
const battle_icon = preload("res://Asset/Attack_Phase_Icon.png")

const CardBase = preload("res://Cards/CardBase.tscn") #preloading the CardBase
const CardFocus = preload("res://Cards/CardBase.gd")
var CardSize = Vector2(125,175) #This is half the size of the card

# The PlayerDeck has to be a 2D array, [CardName, CardType]
const PlayerDeck = [["Umbot_Lanu", "Creatures"], ["Umbot_Lanu", "Creatures"], ["Umbot_Lanu", "Creatures"], ["Umbot_Lanu", "Creatures"], ["Umbot_Lanu", "Creatures"],
["Umbot_Plum", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Plum", "Creatures"], ["Umbot_Plum", "Creatures"],
["Umbot_Zuma", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Zuma", "Creatures"], ["Umbot_Zuma", "Creatures"],
["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"], ["Umbot_Skal", "Creatures"],
["Umbot_Fisa", "Creatures"], ["Umbot_Fisa", "Creatures"], ["Umbot_Fisa", "Creatures"], ["Umbot_Fisa", "Creatures"], ["Umbot_Fisa", "Creatures"],
["Umbot_Champion_Vila", "Creatures"], ["Umbot_Champion_Vila", "Creatures"], ["Umbot_Champion_Vila", "Creatures"], ["Umbot_Champion_Vila", "Creatures"], ["Lunarbird_Eule", "Creatures"], ["Lunarbird_Eule", "Creatures"],
["Lunarbird_Eule", "Creatures"], ["Lunarbird_Eule", "Creatures"], ["Lunarbird_Eule", "Creatures"], ["Counter", "Spells"],
["Counter", "Spells"], ["Counter", "Spells"], ["Counter", "Spells"], ["Counter", "Spells"], ["Umbot_Parade", "Spells"], ["Umbot_Parade", "Spells"], ["Umbot_Parade", "Spells"], ["Umbot_Factory", "Spells"],
["Umbot_Factory", "Spells"], ["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Clear Weather", "Spells"],
["Clear_Weather", "Spells"], ["Clear_Weather", "Spells"], ["Clear_Weather", "Spells"], ["Copy_Machine", "Spells"],
["Copy_Machine", "Spells"], ["Copy_Machine", "Spells"], ["Copy_Machine", "Spells"], ["Bird_Call", "Spells"], ["Bird_Call", "Spells"], ["Bird_Call", "Spell"],
["Bird_Call", "Spells"], ["Bird_Call", "Spells"]]
#var PlayerDeck = deck_node.deck

var GraveArr = []

onready var pm = $PopupMenu

var CardSelected = [] # Holds an int
var DeckSize = PlayerDeck.size()

var PlayerHandSize = 0

var cardCounters = []

var PlayerHealth
var OpponentHealth

var click_pos

var phase
var cards_playable = false
var battling = false

var selected_card

var chance = rand_range(0,101)
var weather
var default_weather

var energy
var start_energy

var paused = false

var squish_factor = 0

#var windowWidth = ProjectSettings.get_setting("display/window/size/width")
#var windowHeight = ProjectSettings.get_setting("display/window/size/height")
#var window = Vector2(windowWidth, windowHeight)

var incrementer = 0
var fieldIncrementer = 0

func checkWeather(percent):
	if percent < 55:
		default_weather = 0
	elif percent >= 55 and percent < 70:
		default_weather = 1
	elif percent >= 70 and percent < 80:
		default_weather = 2
	elif percent >= 80 and percent < 99:
		default_weather = 3
	else:
		default_weather = 4

# Draws a card from the deck
func drawCard():
	if DeckSize <= 0:
		get_tree().change_scene("res://MainMenu.tscn")
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
	updateHand()

func mill():
	if DeckSize <= 0:
		return
	
	var new_card = CardBase.instance() # The CardBase node is initialized
	new_card.CardType = PlayerDeck[0][1]
	new_card.CardName = PlayerDeck[0][0]
	
	var PlayerDeckNode = get_node("Graveyard/GraveCards")
	var CardPos_x = PlayerDeckNode.rect_global_position.x
	var CardPos_y = PlayerDeckNode.rect_global_position.y
	new_card.rect_position = Vector2(CardPos_x, CardPos_y) # Assigns a global position to the card with respect to its container
	new_card.rect_scale *= CardSize/new_card.rect_size # Re-scaling to fit the playspace
	
	$Graveyard.add_child(new_card)
	GraveArr.append([new_card.CardName, new_card.CardType])
	PlayerDeck.remove(0)
	DeckSize -= 1

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
	energy -= card.cost
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
	updateHand()

func updateHand():
	incrementer = 0
	var cards = $Cards.get_children()
	if $Cards.get_child_count() > 8:
		squish_factor = ($Cards.get_child_count() - 7) * 7
	else:
		squish_factor = 0
	for card in cards:
		var PlayerDeckNode = get_node("VBoxContainer/Player1Side/VBoxContainer/HBoxContainer/VBoxContainer/PlayerDeck")
		var CardPos_x = PlayerDeckNode.rect_global_position.x
		var CardPos_y = PlayerDeckNode.rect_global_position.y
		card.rect_position = Vector2(CardPos_x+incrementer, CardPos_y)
		incrementer += 100 - squish_factor

func killCard(card):
	if card.get_parent() == $Cards:
		$Cards.remove_child(card)
		var graveyard = get_node("Graveyard/GraveCards")
		var CardPos_x = graveyard.rect_global_position.x
		var CardPos_y = graveyard.rect_global_position.y
		card.rect_position = Vector2(CardPos_x, CardPos_y)
		card.rect_scale *= CardSize/card.rect_size
		$Graveyard.add_child(card)
		updateHand()
	elif card.get_parent() == $PlayerField:
		$PlayerField.remove_child(card)
		var graveyard = get_node("Graveyard/GraveCards")
		var CardPos_x = graveyard.rect_global_position.x
		var CardPos_y = graveyard.rect_global_position.y
		card.rect_position = Vector2(CardPos_x, CardPos_y)
		card.rect_scale *= CardSize/card.rect_size
		$Graveyard.add_child(card)
		GraveArr.append([card.CardName, card.CardType])
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
	pm.clear()
	if selected_card.cost <= energy:
		pm.add_item("Play", PopupId.PLAY)
	pm.add_item("Discard", PopupId.KILL)
	pm.add_item("Shuffle", PopupId.SHUFFLE)

func field_pop():
	pm.clear()
	if phase == 2 and !selected_card.has_attacked:
		pm.add_item("Attack", PopupId.ATTACK)
	pm.add_item("Kill", PopupId.KILL)
	pm.add_item("Return to Hand", PopupId.ADDTOHAND)
	pm.add_item("Shuffle", PopupId.SHUFFLE)

func deck_pop():
	pm.clear()
	if DeckSize > 0:
		pm.add_item("Draw", PopupId.DRAW)
		pm.add_item("Mill", PopupId.MILL)
		pm.add_item("Shuffle", PopupId.SHUFFLEDECK)
		pm.add_item("View", PopupId.VIEWDECK)
	pm.add_item("Forfeit", PopupId.FORFEIT)

func grave_pop():
	pm.clear()
	pm.add_item("View", PopupId.VIEWGRAVE)

var checking_attacks = false
var attack_target

func attack(card):
	if $OppField.get_child_count() == 0:
		OpponentHealth -= card.atk
		print(OpponentHealth)
	else:
		checking_attacks = true
		attack_target.hp -= card.atk
	
	card.has_attacked = true

func debug():
	paused = !paused

func _input(event):
	if Input.is_action_just_released("leftclick") and !paused:
		click_pos = event.position
		
		if checking_attacks:
			for card in $OppField.get_children():
				if card.state == "InHand":
					attack_target = card
					checking_attacks = false
					return
			checking_attacks = false
		
		var cards = $Cards.get_children()
		for card in cards:
			if card.state == "InHand":
				selected_card = card
				pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
				hand_pop()
				return
		
		
		var field = $PlayerField.get_children()
		for card in field:
			if card.state == "InHand":
				selected_card = card
				pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
				field_pop()
	
	if Input.is_action_just_pressed("Scene Debug"):
		debug()

func _on_PopupMenu_id_pressed(id):
	match id:
		PopupId.PLAY:
			playCard(selected_card)
		PopupId.KILL:
			killCard(selected_card)
		PopupId.SHUFFLE:
			shuffle_card(selected_card)
		PopupId.ADDTOHAND:
			return_card_to_hand(selected_card)
		PopupId.ATTACK:
			attack(selected_card)
		PopupId.DRAW:
			drawCard()
		PopupId.MILL:
			mill()
		PopupId.SHUFFLEDECK:
			PlayerDeck.shuffle()
		PopupId.VIEWDECK:
			pass
		PopupId.FORFEIT:
			get_tree().change_scene("res://MainMenu.tscn")
		PopupId.VIEWGRAVE:
			pass

func _on_PopupMenu_index_pressed(index):
	pass

func process_phases():
	match(phase):
		0:
			print("Draw Phase")
			energy = start_energy
			for card in $PlayerField.get_children():
				card.has_attacked = false
			cards_playable = false
			battling = false
			drawCard()
			phase = 1
			process_phases()
		1:
			print("Main Phase")
			$PhaseBox/PhaseSprite.set_texture(main_icon)
			cards_playable = true
			battling = false
		2:
			print("Battle Phase")
			$PhaseBox/PhaseSprite.set_texture(battle_icon)
			cards_playable = false
			battling = true
		3:
			print("End Phase")
			$PhaseBox/PhaseSprite.set_texture(null)
			if start_energy < 20:
				start_energy += 2
			cards_playable = false
			battling = false

func _process(delta):
	$PlayerHealth/Label.text = str(PlayerHealth)
	$OppHealth/Label.text = str(OpponentHealth)
	
	if PlayerHealth <= 0:
		print("You Lose!")
		get_tree().change_scene("res://MainMenu.tscn")
	if OpponentHealth <= 0:
		print("You Win!")
		get_tree().change_scene("res://MainMenu.tscn")
	
	for card in $PlayerField.get_children():
		if card.hp <= 0:
			killCard(card)
			card.hp = card.base_hp
	
	for card in $OppField.get_children():
		if card.hp <= 0:
			$OppField.remove_child(card)
	
	if $DrawDeck/DrawButton.deck_clicked:
		pm.popup(Rect2(click_pos.x, click_pos.y, pm.rect_size.x, pm.rect_size.y))
		deck_pop()
	
	if $Graveyard/GraveCards.grave_clicked:
		pm.popup(Rect2(click_pos.x, click_pos.y, pm.rect_size.x, pm.rect_size.y))
		grave_pop()
	
	if $NextPhaseNode/NextPhaseButton.next_clicked and phase < 3:
		phase += 1
		process_phases()

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
	checkWeather(chance)
	print(chance)
	weather = default_weather
	print(weather)
	for i in range(7):
		drawCard()
	PlayerHealth = 40
	OpponentHealth = 40
	start_energy = 4
	phase = 0
	process_phases()
