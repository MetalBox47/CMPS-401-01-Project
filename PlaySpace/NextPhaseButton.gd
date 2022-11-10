extends TextureButton

var next_clicked = false

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		next_clicked = true

func _process(delta):
	next_clicked = false
