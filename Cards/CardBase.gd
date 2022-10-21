extends MarginContainer

# Database variables are preloaded
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
onready var creatures = CardDatabase.DATA.Creatures
onready var spells = CardDatabase.DATA.Spells
onready var creatures_arr = CardDatabase.CREATURES

# We define the variables that are gonna be necessary to extract the assets
var CardType = "Creatures"
var CardName = "Umbot_Skal"

# Here we filter which Card Background and which Card Image to use
# Card Background => Frame (Depends on rarity)
# Card Image => The small img inside the Frame (depends on card name)
onready var CardInfo = CardDatabase.DATA[CardType][CardName]
onready var CardImg = str("res://Assets/",CardInfo.name, ".png")
onready var CardBackgroundImg = str("res://Asset/",CardInfo.rarity,".png")

var CardTexture
var CardImgContainer
var CardSize = rect_size
# rect_size is the size of the "CardBase" container
# We may not use CardSize, this is just to show how to extract it.
func _ready():
	# loading the small CardImg and setting its scale to the card borders
	CardImgContainer = get_node("HBoxContainer/Elements/CardImgContainer")
	CardTexture = get_node("HBoxContainer/Elements/CardImgContainer/Card")
	$HBoxContainer/Elements/CardImgContainer/Card.texture = load(CardImg)
	$HBoxContainer/Elements/CardImgContainer/Card.scale *= CardImgContainer.get_size()/CardTexture.texture.get_size()
#	$Focus.rect_scale *= CardSize/$Focus.rect_size
	# Loading the background texture
	$Background.texture = load(CardBackgroundImg)
	
	var cost = CardInfo["cost"]
	$HBoxContainer/Elements/TopBar/Title/Title.text = CardInfo["name"]
	$HBoxContainer/Elements/Effect/Label.text = CardInfo["effect"]
	match CardType:
		# This is a switch statement, if you want to add "Spells" key, you can.
		"Creatures":
			var Attack = CardInfo["top_counter"]
			var Health = CardInfo["bot_counter"]
			$HBoxContainer/Elements/HBoxContainer/Health/Label.text = str(Health)
			$HBoxContainer/Elements/HBoxContainer/Attack/Label.text = str(Attack)
	
	# Re-scales the invisible button to be hovered
	$Focus.rect_scale *= CardSize/$Focus.rect_size
	print($Background.scale)
	print(CardTexture.texture.get_size())
	
# List of scales to be used for the card onhover resizing
var state = "OutHand"
var inPlay = false
onready var new_scale = rect_scale * 1.1
onready var original_scale = rect_scale

func _physics_process(delta):
	match state:
		"InHand":
			rect_scale = new_scale
		"OutHand":
			rect_scale = original_scale

# functions that emit signals to resize the card when mousehovered
func _on_Focus_mouse_entered(): 
	if !inPlay:
		state = "InHand"
func _on_Focus_mouse_exited():
	state = "OutHand"

func setPlay(b):
	inPlay = b
