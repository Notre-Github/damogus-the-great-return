extends Node3D

var flexing = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_filedialog_show_hidden"):
		flexing = !flexing
		emote(flexing)
	if flexing:
		$SausageRotationPoint.rotation.x += 0.25

func emote(value):
	if value:
		$AudioStreamPlayer.play()
		$MusicPlayer.volume_db = -80
		$HandMesh.show()
		$SausageRotationPoint/SausageMesh.show()
	else:
		$AudioStreamPlayer.stop()
		$MusicPlayer.volume_db = -24
		$HandMesh.hide()
		$SausageRotationPoint/SausageMesh.hide()
