extends MarginContainer

# Database variables are preloaded
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
onready var creatures = CardDatabase.DATA.Creatures
onready var spells = CardDatabase.DATA.Spells
onready var creatures_arr = CardDatabase.CREATURES

# We define the variables that are gonna be necessary to extract the assets
var CardType = 'Spells'
var CardName = 'Umbot_Factory'

# Here we filter which Card Background and which Card Image to use
# Card Background = Frame (Depends on rarity)
# Card Image = The small img inside the Frame (depends on card name)
onready var CardInfo = CardDatabase.DATA[CardType][CardName]
onready var CardImg = str("res://Assets/",CardInfo.name, ".png")
onready var CardBackgroundImg = str("res://Asset/",CardInfo.rarity,".png")

var CardTexture
var CardImgContainer

func _ready():
	
	var CardSize = rect_size  # rect_size is the size of the "CardBase" container
	# We may not use CardSize, this is just to show how to extract it.
	
	# loading the small CardImg and setting its scale to the card borders
	CardImgContainer = get_node("HBoxContainer/Elements/CardImgContainer")
	CardTexture = get_node("HBoxContainer/Elements/CardImgContainer/Card")
	$HBoxContainer/Elements/CardImgContainer/Card.texture = load(CardImg)
	$HBoxContainer/Elements/CardImgContainer/Card.scale *= CardImgContainer.get_size()/CardTexture.texture.get_size()
	
	# Loading the background texture
	$Background.texture = load(CardBackgroundImg)
	match CardType:
		"Spells":
			$HBoxContainer/Elements/TopBar/Title/Title.text = CardInfo["name"]
			$HBoxContainer/Elements/Effect/Label.text = CardInfo["effect"]
		"Creatures":
			var Attack = CardInfo["top_counter"]
			var Health = CardInfo["bot_counter"]
			$HBoxContainer/Elements/TopBar/Title/Title.text = CardInfo["name"]
			$HBoxContainer/Elements/Effect/Label.text = CardInfo["effect"]
			$HBoxContainer/Elements/HBoxContainer/Health/Label.text = str(Health)
			$HBoxContainer/Elements/HBoxContainer/Attack/Label.text = str(Attack)
			
	
		
	
	
	
	print($Background.scale)
	print(CardTexture.texture.get_size())


