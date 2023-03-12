extends CharacterBody3D

const SPEED = 15.0
const JUMP_VELOCITY = 20
const JETPACK_VELOCITY = 1.1

var jetpack_fuel = 7
var jetpack_enable = false

@onready var _spring_arm: SpringArm3D = $Node3D/SpringArm
@onready var _mesh: MeshInstance3D = $%MeshInstance3D

@onready var _fireParticles: GPUParticles3D = $MeshInstance3D/GPUParticles3D
@onready var _uiFuelBar: ProgressBar = $UI/MarginContainer/ProgressBar

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent): # lancer le menu de pause
	if event.is_action_pressed('ui_cancel'):
		$PauseMenu.pause()

func _physics_process(delta):
	_fireParticles.emitting = false
	if not is_on_floor():
		velocity.y -= gravity * delta # gravité appliquée
	
	if is_on_floor(): # reset du jetpack
		jetpack_fuel = 7
		jetpack_enable = false

	if Input.is_action_just_pressed("jump") and is_on_floor(): # gestion du saut
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and !is_on_floor(): # si on appuie une deuxième fois sur espace
		jetpack_enable = true										# déclencher le jetpack

	if Input.is_action_pressed("jump") and jetpack_enable and jetpack_fuel > 0: # jetpack activé
		velocity.y += JETPACK_VELOCITY # ajout de la force du jetpack vers le haut
		jetpack_fuel -= 0.1
		_fireParticles.emitting = true # particules activés

	_uiFuelBar.value = jetpack_fuel # pour l'UI

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back") #vecteur à partir des controles
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y) # on rotate suivant l'angle de la camera

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


func _process(delta):
	move_and_slide() # deprecated : pour le jitter (non kakoh on est pas en pvp pot)
	_spring_arm.position = Vector3(position.x, position.y + 4, position.z) #pour que la cam se déplace avec le joueur (je sais pas pourquoi faut faire ça)
	if velocity.x != 0 or velocity.z != 0 : # si mouvement horizontale, tourner le personnage
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(-velocity.x, -velocity.z), 13 * delta)
