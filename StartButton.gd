extends Area2D

func _ready():
	var button = Button.new()
	button.text = "Start Game"
	button.connect("pressed", self, "_button_pressed")
	add_child(button)

func _button_pressed():
	get_tree().change_scene(("res://Overworld.tscn"))
