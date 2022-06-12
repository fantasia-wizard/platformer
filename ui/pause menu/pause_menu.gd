extends Control

func _ready():
	visible = false
	$NinePatchRect/HBoxContainer2/CheckButton.pressed = Global.buttons

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed('menu'):
		visible = not visible
		get_tree().paused = visible

func _on_Button3_pressed():
	visible = false
	get_tree().paused = false


func _on_Button_pressed():
	Global.reset()

func _on_Button2_pressed():
	get_tree().quit()


func _on_CheckButton_toggled(value):
	Global.buttons = value
