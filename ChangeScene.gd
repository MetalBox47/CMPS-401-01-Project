extends Sprite

func get_input():
	if Input.is_action_just_pressed("Scene Debug"):
		get_tree().change_scene(("res://Overworld.tscn"))

func _physics_process(delta):
	get_input()
