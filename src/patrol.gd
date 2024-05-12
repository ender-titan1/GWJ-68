extends CharacterBody2D

# Exports
@export var player: CharacterBody2D
@export var vision_range: float
@export var max_degrees: float
@export var vision_cone_multiplier: float

# Nodes
@onready var vision_cone: Sprite2D = $"Sprite2D2"

# Variables
var max_radians: float
var forward_vector: Vector2
var forward_radians: float

func _ready():
	max_radians = deg_to_rad(max_degrees)
	forward_radians = deg_to_rad(rotation_degrees)
	forward_vector = Vector2(cos(forward_radians), sin(forward_radians))
	
	# Set up shader properties
	vision_cone.material.set_shader_parameter("range", vision_range)
	vision_cone.material.set_shader_parameter("rads", max_radians)
	vision_cone.material.set_shader_parameter("fwd_vec", forward_vector)
	vision_cone.material.set_shader_parameter("color", Color.AQUA)
	
	generate_texture()
	
func generate_texture():
	var texture = GradientTexture2D.new()
	texture.width = vision_range * 2 * vision_cone_multiplier
	texture.height = vision_range * 2 * vision_cone_multiplier
	
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.0, 0.0)
	
	var gradient = Gradient.new()
	var gradient_data = {
		0.0: Color.WHITE,
		0.8: Color.TRANSPARENT
	}
	
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()
	
	texture.gradient = gradient
	
	vision_cone.texture = texture

func _process(delta):
	var spotted = player_in_cone() && line_of_sight(player.get_node("CollisionShape2D"))
	
	if spotted:
		vision_cone.material.set_shader_parameter("color", Color.RED)
	else:
		vision_cone.material.set_shader_parameter("color", Color.AQUA)
	
func _physics_process(delta):
	# Update the shader's position 
	vision_cone.material.set_shader_parameter("pos", position)
	
	# Update the forward vector and corresponding shader param.
	forward_radians = deg_to_rad(rotation_degrees)
	forward_vector = Vector2(cos(forward_radians), sin(forward_radians))
	vision_cone.material.set_shader_parameter("fwd_vec", forward_vector)
	
func player_in_cone() -> bool:
	var player_pos = player.position
	var dist = player_pos.distance_to(position)
	
	if dist > vision_range:
		return false
	
	# using the formula for degree between two vectors:
	# cos(a) = (u . v) / (|u| * |v|)
	
	var vector_to_player = (player_pos - position).normalized()
	var dot = vector_to_player.dot(forward_vector)
	
	# Since both vector are normalized, no need to calculate magnitude
	var angle = acos(dot / 1)
	
	return angle <= max_radians
	
func line_of_sight(target: CollisionShape2D):
	var world = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	var result = world.intersect_ray(query)
	
	print(result.collider)
	
	if result:
		var collider = result.collider
		return collider == target
	
	return false
