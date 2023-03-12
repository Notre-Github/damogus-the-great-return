extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var playButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/ResumeButton
@onready var optionButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/OptionButton
@onready var quitButton: Button = $CenterContainer/PauseMenu/MarginContainer/VBoxContainer/QuitButton

@onready var fullscreen: Button = $OptionCenterContainer/OptionMenu/MarginContainer/VBoxContainer/HBoxContainer/Fullscreen
@onready var backButton: Button = $OptionCenterContainer/OptionMenu/MarginContainer/VBoxContainer/BackButton

@onready var textSens: Label = $OptionCenterContainer/OptionMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Sens

signal mouse_sens(sens)

signal fov(value)

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

func _on_resolution_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_h_slider_value_changed(value):
	textSens.text = str(value)
	mouse_sens.emit(value)

func _on_fov_slider_value_changed(value):
	fov.emit(value)
