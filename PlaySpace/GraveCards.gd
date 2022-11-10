extends HBoxContainer

var grave_clicked = false

func _process(delta):
	grave_clicked = false

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		grave_clicked = true
