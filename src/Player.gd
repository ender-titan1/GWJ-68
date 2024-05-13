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
		$AnimatedSprite2D.stop()

func check_in_shadow() -> bool:
	var light_group = $"/root/Constants".LIGHT_GROUP
	
	var lights = get_tree().get_nodes_in_group(light_group)
	var world = get_world_2d().direct_space_state
	var in_shadow = true
	
	for light in lights:
		var range_sq = light.range*light.range
		var dist_sq = global_position.distance_squared_to(light.position)
		
		if dist_sq > range_sq:
			continue
		
		var query = PhysicsRayQueryParameters2D.create(
			global_position, light.global_position, $"/root/Constants".LIGHT_RAYCAST_MASK)
		query.collide_with_areas = true
		var result = world.intersect_ray(query)
		
		if result:
			var collider = result.collider
			if in_shadow && collider.get_node("..").is_in_group(light_group):
				in_shadow = false
				break
	
	return in_shadow
