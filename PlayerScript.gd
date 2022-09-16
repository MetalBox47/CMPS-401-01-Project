extends KinematicBody2D

export (int) var speed = 300

var inventory_open = false

func do_inventory():
	if inventory_open:
		inventory_open = false
		print("Inventory Closed")
	else:
		inventory_open = true
		print("Inventory Opened")

func do_pause():
	if get_parent().paused:
		get_parent().paused = false
		print("Unpaused")
	else:
		get_parent().paused = true
		print("Paused")

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if !get_parent().paused:
		if Input.is_action_pressed("Right"):
			velocity.x += 1
		if Input.is_action_pressed("Left"):
			velocity.x -= 1
		if Input.is_action_pressed("Up"):
			velocity.y -= 1
		if Input.is_action_pressed("Down"):
			velocity.y += 1
		if Input.is_action_just_pressed("Inventory"):
			do_inventory()
		
	if Input.is_action_just_pressed("Pause"):
		do_pause()
	
	velocity = velocity.normalized() * speed
	
	#Test Code
	if Input.is_action_just_pressed("Scene Debug"):
		get_tree().change_scene(("res://Duel.tscn"))

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
