extends Camera2D
@onready var Player = $"../CharacterBody2D"


func _ready():
	pass


func _process(delta):
	self.global_position = Player.global_position
	if self.global_position.x < 0:
		self.global_position.x = 0
	if self.global_position.y < 0:
		self.global_position.y = 0
