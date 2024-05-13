extends CharacterBody2D

@export var speed: float = 50.0

func _physics_process(delta):
	var x_axis = Input.get_axis("player_move_left", "player_move_right")
	var y_axis = Input.get_axis("player_move_up", "player_move_down")
	var dir := Vector2(x_axis, y_axis)
	
# set velocity
	velocity = dir * (speed * (1+delta))
	
# call move_and_slide to collide with the walls
	move_and_slide()
# choose animation
	if dir == Vector2.RIGHT:
		$AnimatedSprite2D.play("walking_side")
		$AnimatedSprite2D.flip_h = false
	elif dir == Vector2.LEFT:
		$AnimatedSprite2D.play("walking_side")
		$AnimatedSprite2D.flip_h = true
	elif dir == Vector2.UP:
		$AnimatedSprite2D.play("walking_up")
	elif dir == Vector2.DOWN:
		$AnimatedSprite2D.play("walking_down")


	if dir == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
