extends Node

## A utility function to simplify raycasting, returns an array containing
## whether or not the cast hit and the [CollisionObject2D] that it hit
func raycast(canvas_item: CanvasItem, 
	from: Vector2, to: Vector2, mask: int, intersect_areas: bool = false) -> Array:
	
	var world = canvas_item.get_world_2d().direct_space_state
	# Then raycast to the light to see if we are not standing in a shadow
	var query = PhysicsRayQueryParameters2D.create(from, to, mask)
	query.collide_with_areas = intersect_areas
	var result = world.intersect_ray(query)
	
	if !result:
		return [false, null]
	else:
		return [true, result.collider]

func in_vision_cone(soruce: CanvasItem,
	target: CanvasItem, forward_vector: Vector2, max_radians: float, _range: float) -> bool:
	
	var pos = soruce.position
	var target_pos = target.position
	var dist = target_pos.distance_to(pos)
	
	if dist > _range:
		return false
	
	# using the formula for degree between two vectors:
	# cos(a) = (u . v) / (|u| * |v|)
	
	var vec_to_target = (target_pos - pos).normalized()
	var dot = vec_to_target.dot(forward_vector)
	
	# Since both vector are normalized, no need to calculate magnitude
	var angle = acos(dot / 1)
	
	return angle <= max_radians
