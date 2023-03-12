extends SpringArm3D

@export var mouse_sensitivity = 0.15

@export var controller_sensitivity = 2

#@onready var _mesh: MeshInstance3D = $%MeshInstance3D

func _ready():
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -75, 50)

		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

		#_mesh.rotation_degrees.y = rotation_degrees.y
		
func _process(delta):
	var input_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotation_degrees.x -= input_dir.y * controller_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -75, 50)

	rotation_degrees.y -= input_dir.x * controller_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
