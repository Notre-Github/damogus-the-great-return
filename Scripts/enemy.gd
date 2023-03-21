extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var _mesh : MeshInstance3D = $Area3D/MeshInstance3D

var SPEED = 1.0

var health = 1.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta # gravité appliquée

	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = Vector3(new_velocity.x, velocity.y, new_velocity.z)
	move_and_slide()

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _process(delta):
	move_and_slide() # deprecated : pour le jitter (non kakoh on est pas en pvp pot)
	if velocity.x != 0 or velocity.z != 0 : # si mouvement horizontale, tourner le personnage
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(-velocity.x, -velocity.z), 13 * delta)


func _on_area_3d_body_entered(body):
	print("pog")
	if body.is_in_group("PlayerAttack"):
		hide()
