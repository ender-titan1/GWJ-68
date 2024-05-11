extends CharacterBody2D

@export var speed: float = 50.0

func _physics_process(delta):
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var y_axis = Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(x_axis, y_axis)
	
	# set velocity
	velocity = dir * speed
	
	# call move_and_slide to collide with the walls
	move_and_slide()
