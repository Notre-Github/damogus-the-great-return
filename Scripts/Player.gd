extends CharacterBody3D

const SPEED = 12
const JUMP_VELOCITY = 20
const JETPACK_VELOCITY = 1.1
const ROLL_SPEED = 14
var roll_time = 0.66
var rolling = false
var roll_direction = 0

var jetpack_fuel = 7
var jetpack_enable = false

@onready var _spring_arm: SpringArm3D = $CameraNode/SpringArm
@onready var _mesh: MeshInstance3D = $%PlayerMesh

@onready var _fireParticles: GPUParticles3D = $PlayerMesh/FireParticles
@onready var _uiFuelBar: ProgressBar = $Control/PlayerUI/FuelMargin/FuelProgressBar

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


	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back") #vecteur à partir des controles
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	if Input.is_action_just_pressed("jump") and is_on_floor() and !rolling: # gestion du saut
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and !is_on_floor(): # si on appuie une deuxième fois sur espace
		jetpack_enable = true										# déclencher le jetpack

	if Input.is_action_pressed("jump") and jetpack_enable and jetpack_fuel > 0: # jetpack activé
		velocity.y += JETPACK_VELOCITY # ajout de la force du jetpack vers le haut
		jetpack_fuel -= 0.1
		_fireParticles.emitting = true # particules activés

	_uiFuelBar.value = jetpack_fuel # pour l'UI

	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y) # on rotate suivant l'angle de la camera

	if direction and !rolling:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("roll") and !rolling and is_on_floor(): #déclencheur de la roulade
		if direction: # gestion de l'angle de la roulade selon l'angle de la cam
			roll_direction = Vector2(-direction.x, direction.z).angle() + (3.14 / 2)
		else: # si pas de direction du stick, on prends l'angle du personnage
			roll_direction = _mesh.rotation.y
		rolling = true
	
	if rolling: # la roulade
		roll_time -= delta
		_mesh.rotation.x = roll_time * (1/0.1) # pour faire spin le perso, c'est pepega
		velocity = Vector3(velocity.x, velocity.y, -ROLL_SPEED).rotated(Vector3.UP, roll_direction) # on donne de la vitesse dans la direction de la 1ere frame de la roulade
		
		if roll_time < 0: # roulade finie
			rolling = false
			roll_time = 0.66
			_mesh.rotation.x = 0

func _process(delta):
	move_and_slide() # deprecated : pour le jitter (non kakoh on est pas en pvp pot)
	_spring_arm.position = Vector3(position.x, position.y + 4, position.z) #pour que la cam se déplace avec le joueur (je sais pas pourquoi faut faire ça)
	if velocity.x != 0 or velocity.z != 0 : # si mouvement horizontale, tourner le personnage
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(-velocity.x, -velocity.z), 13 * delta)
