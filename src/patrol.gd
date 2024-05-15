extends CharacterBody2D

# Exports
@export var player: CharacterBody2D
@export var vision_range: float
@export var max_degrees: float
@export var vision_cone_multiplier: float
@export var speed: float

# Nodes
@onready var vision_cone: Sprite2D = $"Sprite2D2"
@onready var path: Path2D = $".."

# Variables
var max_radians: float
var forward_vector: Vector2
var forward_radians: float
var points: PackedVector2Array
var next_point: Vector2
var next_point_idx: int
var initial_point: Vector2

func _ready():
	max_radians = deg_to_rad(max_degrees)
	forward_radians = deg_to_rad(rotation_degrees)
	forward_vector = Vector2(cos(forward_radians), sin(forward_radians))
	
	vision_cone.visible = true

	# Set up the points to follow
	for point_idx in path.curve.point_count:
		points.append(path.curve.get_point_position(point_idx))

	next_point_idx = 0
	next_point = points[next_point_idx]
	initial_point = next_point

	# Set up shader properties
	vision_cone.material.set_shader_parameter("range", vision_range)
	vision_cone.material.set_shader_parameter("rads", max_radians)
	vision_cone.material.set_shader_parameter("fwd_vec", forward_vector)
	vision_cone.material.set_shader_parameter("color", Color.AQUA)
	
	generate_texture()

func _process(_delta):
	var spotted = player_in_cone() && line_of_sight(player)
	
	if spotted:
		vision_cone.material.set_shader_parameter("color", Color.RED)
	else:
		vision_cone.material.set_shader_parameter("color", Color.AQUA)
	
func _physics_process(delta):
	var dir = (next_point - global_position).normalized()
	velocity = dir * speed * delta
	
	move_and_slide()

	# Update the shader's position 
	vision_cone.material.set_shader_parameter("pos", global_position)
	
	# Update the forward vector and corresponding shader param.
	forward_radians = deg_to_rad(rotation_degrees)
	forward_vector = dir
	vision_cone.material.set_shader_parameter("fwd_vec", forward_vector)

	# Check which point to go to next
	var dist = global_position.distance_to(next_point)

	if dist < 0.1:
		next_point_idx += 1
		next_point = points[next_point_idx]

		if next_point == initial_point:
			next_point = initial_point
			next_point_idx = 0


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

	#vision_cone.material = ShaderMaterial.new()
	#vision_cone.material.shader = load("res://src/shader/light_cone.gdshader")
	
func player_in_cone() -> bool:
	return Util.in_vision_cone(self, player, forward_vector, max_radians, vision_range)
	
func line_of_sight(target: CollisionObject2D):
	var res = Util.raycast(self, global_position, target.global_position, Constants.RAYCAST_MASK)

	if res[0]:
		return res[1].name == target.name
	
	return false
