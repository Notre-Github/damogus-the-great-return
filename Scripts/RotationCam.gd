extends SpringArm3D

@export var mouse_sensitivity = 0.15

@export var controller_sensitivity = 2

func _ready():
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # on prends la souris

func _unhandled_input(event):
	if event is InputEventMouseMotion: # si un input se produit, et que c'est un mouvement de souris
		rotation_degrees.x -= event.relative.y * mouse_sensitivity # on bouge la cam suivant la sensi
		rotation_degrees.x = clamp(rotation_degrees.x, -75, 50) # on limite le mouvement

		rotation_degrees.y -= event.relative.x * mouse_sensitivity # on bouge la cam suivant la sensi
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0) # on limite le mouvement

func _process(_delta):
	var input_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down") # pareil, mais avec la manette
	rotation_degrees.x -= input_dir.y * controller_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 75)

	rotation_degrees.y -= input_dir.x * controller_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)


func _on_pause_menu_mouse_sens(sens):
	mouse_sensitivity = sens
