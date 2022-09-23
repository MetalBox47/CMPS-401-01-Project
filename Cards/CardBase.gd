extends MarginContainer


# Declare member variables here. Examples:
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
var CardName = "Counter"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardDatabase.DATA["Creatures"]["Umbot_Skal"].name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
