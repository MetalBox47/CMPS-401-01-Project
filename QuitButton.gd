extends Area2D

func _ready():
	var button = Button.new()
	button.text = "Quit Game"
	button.connect("pressed", self, "_button_pressed")
	add_child(button)

func _button_pressed():
	get_tree().quit()
