extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var playButton: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var optionButton: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var quitButton: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	playButton.pressed.connect(unpause)
	optionButton.pressed.connect(unpause)
	quitButton.pressed.connect(get_tree().quit)

func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
