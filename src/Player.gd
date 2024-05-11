extends CharacterBody2D

@export var speed: float = 50.0

func _process(delta: float) -> void:
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var y_axis = Input.get_axis("ui_up", "ui_down")
	var move := Vector2(x_axis,y_axis)
	
	#movement
	position += move * speed * delta
