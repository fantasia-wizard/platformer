extends Control

# warning-ignore:unused_argument
func _process(delta):
	Global.dead = true


func _on_Button_pressed():
# warning-ignore:return_value_discarded
	Global.position = Vector2(56, 24)
	Global.change_scene('res://levels/overworld/world_1.tscn')
