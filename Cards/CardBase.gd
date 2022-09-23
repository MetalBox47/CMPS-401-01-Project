extends MarginContainer

# Database variables are preloaded
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
onready var creatures = CardDatabase.DATA.Creatures
onready var spells = CardDatabase.DATA.Spells
onready var creatures_arr = CardDatabase.CREATURES

onready var CardImg = str("res://Assets/",spells["Umbot_Factory"].name, ".png")

var Card
var CardImgContainer
func _ready():
	var CardSize = rect_size  # rect_size is the size of the entire container (CardBase)
	
	# loading the CardImg and setting its scale to the card borders
	CardImgContainer = get_node("HBoxContainer/Elements/CardImgContainer")
	Card = get_node("HBoxContainer/Elements/CardImgContainer/Card")
	Card.texture = load(CardImg)
	Card.scale *= CardImgContainer.get_size()/Card.texture.get_size()
	
	
	print($Background.scale)
	print(Card.texture.get_size())


