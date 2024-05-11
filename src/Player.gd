extends CharacterBody2D

@export var speed: float = 50.0

func _physics_process(_delta):
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var y_axis = Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(x_axis, y_axis)
	
	# set velocity
	velocity = dir * speed
	
	# call move_and_slide to collide with the walls
	move_and_slide()
	
	if dir == Vector2.RIGHT:
		$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip.h = false
	elif dir == Vector2.LEFT:
		$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip.h = true
	elif dir == Vector2.UP:
		$AnimatedSprite2D.play("walking_up")
	elif dir == Vector2.DOWN:
		$AnimatedSprite2D.play("walking_down")
		
	if dir == Vector2.ZERO:
		$AnimatedSprite2D.stop()
		
