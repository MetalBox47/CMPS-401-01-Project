extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DeckSize = 1

func _ready():
	rect_scale *= $"../../".CardSize/rect_size

# This enables the button that Draws Cards
func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if DeckSize > 0:
			# Draws a Card first, then reduces the DeckSize until it becomes 0
			$"../../".drawCard()
			DeckSize = $"../../".DeckSize
			if DeckSize == 0:
				disabled = true # Disables the buttton to be used any more
