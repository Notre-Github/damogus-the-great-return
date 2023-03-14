extends DirectionalLight3D

#@onready var _WE: WorldEnvironment = $WorldEnvironment

func _process(delta):
	rotation.x += delta/20
