extends MarginContainer

# Database variables are preloaded
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
onready var creatures = CardDatabase.CREATURES
onready var spells = CardDatabase.SPELLS

onready var CardImg = str("res://Assets/Umbot_Factory.png")
var Card
func _ready():
	
	var CardSize = rect_size  # rect_size is the size of the entire container (CardBase)
	
	# loading the CardImg and setting its scale to the card borders
	Card = get_node("CardImgContainer/Card")
	Card.texture = load(CardImg)
	Card.scale *= $CardImgContainer.get_size()/Card.texture.get_size()
	Card.position = $CardImgContainer.get_position()
	
	print($Background.scale)
	print(Card.texture.get_size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
