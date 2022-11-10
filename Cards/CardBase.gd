extends MarginContainer

# Database variables are preloaded
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
onready var creatures = CardDatabase.DATA.Creatures
onready var spells = CardDatabase.DATA.Spells
onready var creatures_arr = CardDatabase.CREATURES

onready var has_attacked = false

# We define the variables that are gonna be necessary to extract the assets
var CardType = "Creatures"
var CardName = "Umbot_Skal"

# Here we filter which Card Background and which Card Image to use
# Card Background => Frame (Depends on rarity)
# Card Image => The small img inside the Frame (depends on card name)
onready var CardInfo = CardDatabase.DATA[CardType][CardName]
onready var directory = Directory.new()
onready var CardBackgroundImg = str("res://Asset/",CardInfo.rarity,".png")
onready var cost = int(CardInfo.cost)
onready var base_atk
onready var base_hp
onready var atk
onready var hp

var CardTexture
var CardImgContainer
var CardSize = rect_size
# rect_size is the size of the "CardBase" container
# We may not use CardSize, this is just to show how to extract it.

func _ready():
	# loading the small CardImg and setting its scale to the card borders
	CardImgContainer = get_node("HBoxContainer/Elements/CardImgContainer")
	CardTexture = get_node("HBoxContainer/Elements/CardImgContainer/Card")
	if directory.file_exists(str("res://Assets/",CardInfo.name, ".png")):
		var CardImg = str("res://Assets/",CardInfo.name, ".png")
		$HBoxContainer/Elements/CardImgContainer/Card.texture = load(CardImg)
		$HBoxContainer/Elements/CardImgContainer/Card.scale *= CardImgContainer.get_size()/CardTexture.texture.get_size()
#	$Focus.rect_scale *= CardSize/$Focus.rect_size
	# Loading the background texture
	$Background.texture = load(CardBackgroundImg)
	
	$HBoxContainer/Elements/TopBar/Title/Title.text = CardInfo["name"]
	$HBoxContainer/Elements/Effect/Label.text = CardInfo["effect"]
	$HBoxContainer/Elements/Type/Label.add_color_override("font_color", Color(0,0,0,1))
	match CardType:
		# This is a switch statement, if you want to add "Spells" key, you can.
		"Creatures":
			$HBoxContainer/Elements/Type/Label.text = str(CardInfo["type"], " Creature Cost: ", CardInfo["cost"])
			var Attack = CardInfo["top_counter"]
			atk = int(Attack)
			base_atk = atk
			var Health = CardInfo["bot_counter"]
			hp = int(Health)
			base_hp = hp
			$HBoxContainer/Elements/HBoxContainer/Health/Label.text = str(Health)
			$HBoxContainer/Elements/HBoxContainer/Attack/Label.text = str(Attack)
		"Spells":
			$HBoxContainer/Elements/Type/Label.text = str("Spell Cost: ", CardInfo["cost"])
	
	# Re-scales the invisible button to be hovered
	$Focus.rect_scale *= CardSize/$Focus.rect_size

# List of scales to be used for the card onhover resizing
var state = "OutHand"
var inPlay = false
onready var new_scale = rect_scale * 1.1
onready var original_scale = rect_scale

func _physics_process(delta):
	$HBoxContainer/Elements/HBoxContainer/Health/Label.text = str(hp)
	$HBoxContainer/Elements/HBoxContainer/Attack/Label.text = str(atk)
	match state:
		"InHand":
			rect_scale = new_scale
		"OutHand":
			rect_scale = original_scale

# functions that emit signals to resize the card when mousehovered
func _on_Focus_mouse_entered():
	state = "InHand"
func _on_Focus_mouse_exited():
	state = "OutHand"

func setPlay(b):
	inPlay = b
