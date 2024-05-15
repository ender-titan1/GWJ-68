extends StaticBody2D 


func _on_area_2d_body_entered(body):
	if Input.is_action_just_pressed("player_interact"):
		print('door open')
