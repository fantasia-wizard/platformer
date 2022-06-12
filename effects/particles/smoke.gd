extends Particles2D

func _ready():
	if randi() %2 == 0:
		queue_free()

func _process(_delta):
	if not emitting:
		queue_free()
