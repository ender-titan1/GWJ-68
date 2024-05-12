extends CharacterBody2D

@export var player: CharacterBody2D
@export var vision_range: float
@export var max_degrees: float

var max_radians: float
var forward_radians: float

func _ready():
	max_radians = deg_to_rad(max_degrees)

func _process(delta):
	queue_redraw()
	
func player_spotted() -> bool:
	var player_pos = player.position
	var dist = player_pos.distance_to(position)
	
	if dist > vision_range:
		return false
	
	# using the formula for degree between two vectors:
	# cos(a) = u * v / |u| * |v|
	
	var vector_to_player = (player_pos - position).normalized()
	var forward_vector = Vector2(cos(forward_radians), sin(forward_radians))
	var dot = vector_to_player.dot(forward_vector)
	
	# Since both vector are normalized, no need to calculate magnitude
	var angle = acos(dot / 1)
	draw_line(Vector2.ZERO, forward_vector * 50, Color.YELLOW)
	
	if angle > max_radians:
		draw_line(Vector2.ZERO, player_pos - position, Color.RED)
	else:
		draw_line(Vector2.ZERO, player_pos - position, Color.GREEN)
	
	return true

func _draw():
	player_spotted()
	
