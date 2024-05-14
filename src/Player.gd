extends CharacterBody2D

@export var speed: float = 50.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dash_input: bool = false
var can_dash: bool = true

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
		sprite.play("walking_side")
		sprite.flip_h = false
	elif dir == Vector2.LEFT:
		sprite.play("walking_side")
		sprite.flip_h = true
	elif dir == Vector2.UP:
		sprite.play("walking_up")
	elif dir == Vector2.DOWN:
		sprite.play("walking_down")

	if dir == Vector2.ZERO:
		sprite.play("idle")

func _process(_delta):
	if dash_input:
		var in_shadow = Util.pos_in_shadow(self, global_position)

		if !in_shadow:
			can_dash = false
			return

		var target = get_global_mouse_position()
		var result = Util.raycast(self, global_position, target, Constants.RAYCAST_MASK)

		# We want to check if nothing in in the way or at the end of the dash
		if result[0]:
			can_dash = false
			return

		can_dash = true



func _input(event):
	if event.is_action_pressed("player_move_special"):
		dash_input = true
		queue_redraw()
	
	if event.is_action_released("player_move_special"):
		dash_input = false
		queue_redraw()

func _draw():
	if dash_input:
		draw_arc(Vector2.ZERO, 100, 0, TAU, 180, Color.GREEN)
