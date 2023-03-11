extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 20

@onready var _spring_arm: SpringArm3D = $Node3D/SpringArm
@onready var _mesh: MeshInstance3D = $%MeshInstance3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta):
	_spring_arm.position = Vector3(position.x, position.y + 2, position.z)
	if velocity != Vector3.ZERO:
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(-velocity.x, -velocity.z), 10 * delta)
		_mesh.rotation.y
