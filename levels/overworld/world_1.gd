extends Node2D

# warning-ignore:unused_argument
func _on_death_box_body_entered(body):
# warning-ignore:return_value_discarded
	Global.change_scene('res://ui/misc/death.tscn')
