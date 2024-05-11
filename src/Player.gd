extends CharacterBody2D

@export var speed: float = 50.0

func _process(delta: float) -> void:
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var y_axis = Input.get_axis("ui_up", "ui_down")
	var move := Vector2(x_axis,y_axis)
	
	#movement
	position += move * speed * delta
	
	if move == Vector2(1,0):
		#player moving right
		print('right')
		#flip.h = flase
	elif move == Vector2(-1,0):
		#player moving left
		print('left')
		#flip.h = true
	elif move == Vector2(0,1):
		#player moving up
		print('up')
	elif move == Vector2(0,-1):
		#player moving down
		print('down')
		
	if move == Vector2(0,0):
		print('stop')
		#stop all animations
		
		
