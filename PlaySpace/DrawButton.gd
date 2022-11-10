extends TextureButton

var deck_clicked = false

func _process(delta):
	deck_clicked = false

func _ready():
	rect_scale *= $"../../".CardSize/rect_size

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		deck_clicked = true
