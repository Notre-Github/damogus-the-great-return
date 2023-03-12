extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var playButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/ResumeButton
@onready var optionButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/OptionButton
@onready var quitButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/QuitButton

@onready var fullscreen: Button = $OptionCenterContainer/OptionMenu/MarginContainer/VBoxContainer/HBoxContainer/Fullscreen
@onready var backButton: Button = $OptionCenterContainer/OptionMenu/MarginContainer/VBoxContainer/BackButton

func _ready():
	playButton.pressed.connect(unpause)
	optionButton.pressed.connect(optionOpen)
	backButton.pressed.connect(optionClose)
	quitButton.pressed.connect(get_tree().quit)


func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func optionClose():
	animator.play("closeOptions")

func optionOpen():
	animator.play("openOptions")

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
