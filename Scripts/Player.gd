extends CharacterBody3D

const SPEED = 15.0
const JUMP_VELOCITY = 20
const JETPACK_VELOCITY = 10

var jetpack_fuel = 7
var jetpack_enable = false

@onready var _spring_arm: SpringArm3D = $Node3D/SpringArm
@onready var _mesh: MeshInstance3D = $%MeshInstance3D

@onready var _uiFuelBar: ProgressBar = $UI/MarginContainer/ProgressBar

@onready var _rc: RayCast3D = $RayCast3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed('ui_cancel'):
		$PauseMenu.pause()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_on_floor():
		jetpack_fuel = 7
		jetpack_enable = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and !is_on_floor():
		jetpack_enable = true

	if Input.is_action_pressed("jump") and jetpack_enable and jetpack_fuel > 0:
		velocity.y = JETPACK_VELOCITY
		jetpack_fuel -= 0.1

	_uiFuelBar.value = jetpack_fuel

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y)

		#print(direction.length())

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta):
	_spring_arm.position = Vector3(position.x, position.y + 2, position.z)
	if velocity.x != 0 or velocity.z != 0 :
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(-velocity.x, -velocity.z), 13 * delta)
