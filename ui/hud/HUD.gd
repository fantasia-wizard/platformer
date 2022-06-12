extends CanvasLayer

# warning-ignore:unused_argument
func _process(delta):
	$Control/empty.rect_size.x = 10*Global.max_health
	$Control/full.rect_size.x = 10*Global.health
	$coins.text = str(Global.coins)
	for x in get_children():
		x.visible = not Global.dead
	$'touch controls'.visible = Global.buttons
