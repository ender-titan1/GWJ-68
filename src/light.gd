extends PointLight2D

@export var range_multiplier: float = 0.0
@onready var default_range_mul: float = $"/root/Constants".DEFAULT_LIGHT_RANGE_MULTIPLIER

var range: float

func _ready():
	if range_multiplier == 0.0:
		range_multiplier = default_range_mul
	
	range = texture.get_width() / 2
	var gradient: Gradient = texture.gradient
	range *= gradient.get_offset(1)
	range *= range_multiplier

	#queue_redraw()

#func _draw():
#	draw_line(Vector2.ZERO, Vector2.UP * range, Color.GREEN)
