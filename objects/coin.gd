extends Area2D

var collected = false

func _ready():
	if name in Global.coins_collected:
		queue_free()

# warning-ignore:unused_argument
func _on_coin_body_entered(body):
	Global.coins += 1
	$CollisionShape2D.set_deferred('disabled', true)
	collected = true
	Global.coins_collected.append(name)

# warning-ignore:unused_argument
func _process(delta):
	if collected:
		modulate.a -= 0.1
		global_position.y -= 0.5
