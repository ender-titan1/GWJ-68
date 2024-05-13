extends CharacterBody2D

@export var speed: float = 50.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

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

func check_in_shadow() -> bool:
	# Get constants
	var light_group = Constants.LIGHT_GROUP
	var raycast_mask = Constants.LIGHT_RAYCAST_MASK

	# Get world info
	var lights := get_tree().get_nodes_in_group(light_group)
	var in_shadow = true
	
	# Iterate through all present lights in the scene
	for light in lights:
		# First, check if player is in range of the light

		var range_sq = light.range*light.range
		var dist_sq = global_position.distance_squared_to(light.position)
		
		# If not, it means it is not in its light
		if dist_sq > range_sq:
			continue
		
		# Then raycast to the light to see if we are not standing in a shadow
		var res = Util.raycast(self, global_position, light.global_position, light_mask, true)
		
		if res[0]:
			if in_shadow && res[1].get_node("..").is_in_group(light_group):
				in_shadow = false
				break
	
	return in_shadow
