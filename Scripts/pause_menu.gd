extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var playButton: Button = $CenterContainer/PauseMenu/PauseMargin/Menu/ResumeButton
@onready var optionButton: Button = $CenterContainer/PauseMenu/PauseMargin/Menu/OptionButton
@onready var quitButton: Button = $CenterContainer/PauseMenu/PauseMargin/Menu/QuitButton

@onready var backButton: Button = $OptionCenterContainer/OptionMenu/Margin/menu/BackButton

@onready var textSens: Label = $"OptionCenterContainer/OptionMenu/Margin/menu/Options Part1/MouseSens/Text/Value"

signal mouse_sens(sens)

signal fov(value)

func _ready():
	playButton.pressed.connect(unpause) # on assigne aux boutons une fonction qui se lancera quand on clique dessus
	optionButton.pressed.connect(optionOpen)
	backButton.pressed.connect(optionClose)
	quitButton.pressed.connect(get_tree().quit)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # pour récupérer la souris

func optionClose():
	animator.play("closeOptions")

func optionOpen():
	animator.play("openOptions")

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # pour rendre la souris

func _on_resolution_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_h_slider_value_changed(value): # pour changer la sensi
	textSens.text = str(value)
	mouse_sens.emit(value)

func _on_fov_slider_value_changed(value): # pour changer le fov
	fov.emit(value)


func _on_vsync_box_toggled(button_pressed):
	pass
