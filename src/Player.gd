extends CharacterBody2D

@export var speed: float = 50.0
@export var dash_range: float = 150.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var in_shadow: bool
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
	in_shadow = Util.pos_in_shadow(self, global_position)

	if dash_input:
		queue_redraw()
		update_can_dash()


func update_can_dash():
	if dash_input:
		if !in_shadow:
			can_dash = false
			return

		var target = get_global_mouse_position()
		var distance_to_target = target.distance_to(global_position)

		if distance_to_target > dash_range:
			can_dash = false
			return

		var result = Util.raycast(self, global_position, target, Constants.RAYCAST_MASK)

		# We want to check if nothing in in the way or at the end of the dash
		if result[0]:
			can_dash = false
			return

		var target_in_shadow = Util.pos_in_shadow(self, target)

		if !target_in_shadow:
			can_dash = false
			return

		can_dash = true

func dash():
	if can_dash:
		global_position = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("player_move_special"):
		dash_input = true
	
	if event.is_action_released("player_move_special"):
		dash_input = false
		dash()
		queue_redraw()

func _draw():
	if dash_input:
		draw_arc(Vector2.ZERO, dash_range, 0, TAU, 180, Color.GREEN)
		var target = get_global_mouse_position()

		var color = Color.GREEN if can_dash else Color.RED

		draw_arc(target - global_position, 10, 0, TAU, 180, color)
		draw_line(Vector2.ZERO, target - global_position, color)
