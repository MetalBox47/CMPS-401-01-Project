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
	CLOUD
	RAIN
	SUN
	WIND
	ECLIPSE
	DUST
	PHEALTHMAX
	PHEALTHMIN
	PHEALTHUP
	PHEALTHDOWN
	OHEALTHMAX
	OHEALTHMIN
	OHEALTHUP
	OHEALTHDOWN
	ENERGYMAX
	ENERGYMIN
	ENERGYUP
	ENERGYDOWN
}

#onready var deck_node = get_node("/root/DeckBuilder/DeckBuilder")

const main_icon = preload("res://Asset/Main_Phase_Icon.png")
const battle_icon = preload("res://Asset/Attack_Phase_Icon.png")
const cloudy_icon = preload("res://Asset/WeatherIcons/CloudIcon.png")
const rain_icon = preload("res://Asset/WeatherIcons/RainIcon.png")
const sun_icon = preload("res://Asset/WeatherIcons/SunIcon.png")
const wind_icon = preload("res://Asset/WeatherIcons/WindIcon.png")
const eclipse_icon = preload("res://Asset/WeatherIcons/EclipseIcon.png")
const dust_icon = preload("res://Asset/WeatherIcons/DustIcon.png")

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
["Umbot_Factory", "Spells"], ["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Umbot_Factory", "Spells"],["Clear_Weather", "Spells"],
["Clear_Weather", "Spells"], ["Clear_Weather", "Spells"], ["Clear_Weather", "Spells"], ["Copy_Machine", "Spells"],
["Copy_Machine", "Spells"], ["Copy_Machine", "Spells"], ["Copy_Machine", "Spells"], ["Bird_Call", "Spells"], ["Bird_Call", "Spells"], ["Bird_Call", "Spells"],
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

var ending = false
var time = 0
const end_time = 3

var selected_card

var weather
var default_weather

var energy
var start_energy

var squish_factor = 0

#var windowWidth = ProjectSettings.get_setting("display/window/size/width")
#var windowHeight = ProjectSettings.get_setting("display/window/size/height")
#var window = Vector2(windowWidth, windowHeight)

var incrementer = 0
var fieldIncrementer = 0

func win():
	$StatusScreen/StatusLabel.text = "You Win!"
	ending = true

func lose():
	$StatusScreen/StatusLabel.text = "You Lose!"
	ending = true

func set_weather(value):
	if value == 0:
		$WeatherIcon/WeatherSprite.set_texture(cloudy_icon)
	elif value == 1:
		$WeatherIcon/WeatherSprite.set_texture(rain_icon)
	elif value == 2:
		$WeatherIcon/WeatherSprite.set_texture(sun_icon)
	elif value == 3:
		$WeatherIcon/WeatherSprite.set_texture(wind_icon)
	elif value == 4:
		$WeatherIcon/WeatherSprite.set_texture(eclipse_icon)
	elif value == 5:
		$WeatherIcon/WeatherSprite.set_texture(dust_icon)
	
	weather = value

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
		lose()
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
	randomize()
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
		if squish_factor > 75:
			squish_factor = 75
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
	if phase == 2 and selected_card.CardType == "Creatures" and !selected_card.has_attacked:
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

func weather_debug_pop():
	pm.clear()
	pm.add_item("Cloudy", PopupId.CLOUD)
	pm.add_item("Rainy", PopupId.RAIN)
	pm.add_item("Sunny", PopupId.SUN)
	pm.add_item("Windy", PopupId.WIND)
	pm.add_item("Eclipse", PopupId.ECLIPSE)
	pm.add_item("Dust Storm", PopupId.DUST)

func health_debug_pop():
	pm.clear()
	pm.add_item("Set Health to 40", PopupId.PHEALTHMAX)
	pm.add_item("Set Health to 1", PopupId.PHEALTHMIN)
	pm.add_item("Health Up", PopupId.PHEALTHUP)
	pm.add_item("Health Down", PopupId.PHEALTHDOWN)

func opp_health_debug_pop():
	pm.clear()
	pm.add_item("Set Health to 40", PopupId.OHEALTHMAX)
	pm.add_item("Set Health to 1", PopupId.OHEALTHMIN)
	pm.add_item("Health Up", PopupId.OHEALTHUP)
	pm.add_item("Health Down", PopupId.OHEALTHDOWN)

func energy_debug_pop():
	pm.clear()
	pm.add_item("Set Energy to 20", PopupId.ENERGYMAX)
	pm.add_item("Set Energy to 0", PopupId.ENERGYMIN)
	pm.add_item("Energy Up", PopupId.ENERGYUP)
	pm.add_item("Energy Down", PopupId.ENERGYDOWN)

func test_enemy():
	var dummy_lanu = CardBase.instance() # The CardBase node is initialized
	dummy_lanu.CardType = "Creatures"
	dummy_lanu.CardName = "Umbot_Lanu"
	var card_pos_x = $DummyBox.rect_global_position.x
	var card_pos_y = $DummyBox.rect_global_position.y
	dummy_lanu.rect_position = Vector2(card_pos_x, card_pos_y) # Assigns a global position to the card with respect to its container
	dummy_lanu.rect_scale *= CardSize/dummy_lanu.rect_size # Re-scaling to fit the playspace
	$OppField.add_child(dummy_lanu)

var checking_attacks = false
var attacking_card

func attack(card):
	if $OppField.get_child_count() == 0:
		OpponentHealth -= card.atk
		print(OpponentHealth)
	else:
		attacking_card = card
		checking_attacks = true

func _input(event):
	if Input.is_action_just_released("leftclick"):
		click_pos = event.position
		
		var cards = $Cards.get_children()
		for card in cards:
			if card.state == "InHand":
				checking_attacks = false
				selected_card = card
				hand_pop()
				pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
				return
		
		
		var field = $PlayerField.get_children()
		for card in field:
			if card.state == "InHand":
				checking_attacks = false
				selected_card = card
				field_pop()
				pm.popup(Rect2(event.position.x, event.position.y, pm.rect_size.x, pm.rect_size.y))
				return
		
		if checking_attacks:
			for card in $OppField.get_children():
				if card.state == "InHand" and card.CardType == "Creatures":
					card.hp -= attacking_card.atk
					checking_attacks = false
	
	if Input.is_action_just_pressed("Scene Debug"):
		weather_debug_pop()
		pm.popup_centered(Vector2(pm.rect_size.x, pm.rect_size.y))
	
	if Input.is_action_just_pressed("Play Health Debug"):
		health_debug_pop()
		pm.popup_centered(Vector2(pm.rect_size.x, pm.rect_size.y))
	
	if Input.is_action_just_pressed("Opp Health Debug"):
		opp_health_debug_pop()
		pm.popup_centered(Vector2(pm.rect_size.x, pm.rect_size.y))
	
	if Input.is_action_just_pressed("Energy Debug"):
		energy_debug_pop()
		pm.popup_centered(Vector2(pm.rect_size.x, pm.rect_size.y))
	
	if Input.is_action_just_pressed("Summon Enemy"):
		test_enemy()

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
			lose()
		PopupId.VIEWGRAVE:
			pass
		PopupId.CLOUD:
			set_weather(0)
		PopupId.RAIN:
			set_weather(1)
		PopupId.SUN:
			set_weather(2)
		PopupId.WIND:
			set_weather(3)
		PopupId.ECLIPSE:
			set_weather(4)
		PopupId.DUST:
			set_weather(5)
		PopupId.PHEALTHMAX:
			PlayerHealth = 40
		PopupId.PHEALTHMIN:
			PlayerHealth = 1
		PopupId.PHEALTHUP:
			PlayerHealth += 1
		PopupId.PHEALTHDOWN:
			PlayerHealth -= 1
		PopupId.OHEALTHMAX:
			OpponentHealth = 40
		PopupId.OHEALTHMIN:
			OpponentHealth = 1
		PopupId.OHEALTHUP:
			OpponentHealth += 1
		PopupId.OHEALTHDOWN:
			OpponentHealth -= 1
		PopupId.ENERGYMAX:
			energy = 20
		PopupId.ENERGYMIN:
			energy = 0
		PopupId.ENERGYUP:
			energy += 1
		PopupId.ENERGYDOWN:
			energy -= 1

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
	if ending:
		time += delta
		if time > end_time:
			emit_signal("timeout")
			time = 0
			get_tree().change_scene("res://MainMenu.tscn")
	
	$PlayerHealth/Label.text = str("Health: ", PlayerHealth)
	$Energy/Label.text = str("Energy: ", energy)
	$OppHealth/Label.text = str("OppHealth: ", OpponentHealth)
	
	if PlayerHealth <= 0:
		win()
	if OpponentHealth <= 0:
		lose()
	
	for card in $PlayerField.get_children():
		if card.CardType == "Creatures":
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
	randomize()
	PlayerDeck.shuffle()
	var chance = rand_range(0,101)
	checkWeather(chance)
	print(chance)
	set_weather(default_weather)
	print(weather)
	for i in range(7):
		drawCard()
	PlayerHealth = 40
	OpponentHealth = 40
	start_energy = 20
	phase = 0
	process_phases()
