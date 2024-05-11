extends Camera2D
@onready var Player = $"../CharacterBody2D"


func _ready():
	pass


func _process(delta):
#this makes sure that the camera cannot go out of bounds the map, assuming the map starts at 0,0.
#however, this does not chenck for lower and right bounds only top and left. also, only works in 32x32
	self.global_position = Player.global_position
	if self.global_position.x < 83:
		self.global_position.x = 83
	if self.global_position.y < 33:
		self.global_position.y = 33
