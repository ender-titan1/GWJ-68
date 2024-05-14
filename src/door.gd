extends StaticBody2D

func _init(event):
	if Input.is_action_just_pressed("player_interact"):
		print('door open')
