extends KinematicBody2D

var velocity = Vector2.ZERO
var max_speed = 50
var acceleration = 350
var last_input = 1
var floating = 0
var state = MOVE
var input = 0
var dash = false
var smoke = preload('res://effects/particles/smoke.tscn')
var sparkle = preload('res://effects/particles/sparkle.tscn')
var double_jump = false

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

enum{#states
	MOVE
	ATTACK
}
func _physics_process(delta):
	global_position = Global.position
	if on_ground():
		dash = true
	Global.dead = false
	if Input.is_action_just_pressed('attack') and state == MOVE and dash:
		state = ATTACK
	process_gravity(delta)
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
	friction(delta)
	velocity = move_and_slide(velocity)#Move by whatever vectors were decided in the previous functions.
	sprite.flip_h = (last_input < 0 or abs(rotation_degrees) > 90) and not (last_input < 0 and abs(rotation_degrees) > 90) #If we are moving left, flip the sprite.
	if is_on_wall() and velocity:
		var normal = get_last_slide_collision().normal
		rotation_degrees = rad2deg(atan2(normal.y, normal.x))+90
	Global.position = global_position

func move_state(delta):
	animation_player.play('idle')
	input = Input.get_axis('ui_left', 'ui_right')#capture the input
	if Input.is_action_just_pressed('jump') and (double_jump or on_ground()):#If we want to jump, apply an upwards force.
		if not on_ground():
			double_jump = false
		velocity.y = (100+abs(velocity.x)/3)*-1
# warning-ignore:unused_variable
		for x in range(0, 16):
			smoke_puff()
	if abs(input) > 0.5:
		last_input = input
	if input:#If we are trying to move
		velocity.x = clamp(velocity.x + input*delta*acceleration, -max_speed, max_speed)#add velocity and clamp to max speed


func friction(delta):
	if on_ground() and not input: #If we aren't moving and we are on the ground, we should slow down and stop.
		if velocity.x > 0: #Decide wether to increase or lower our velocity.
			velocity.x -= acceleration*delta
			if velocity.x < 1:#If we are close, round it off to zero so we don't wobble.
				velocity.x = 0
		else:
			velocity.x += acceleration*delta
			if velocity.x > -1:
				velocity.x = 0
	else: #If we aren't moving or on the ground, air resistance will still stop us a little.
		if velocity.x > 0:
			velocity.x -= acceleration*delta*0.1
			if velocity.x < 1:
				velocity.x = 0
		else:
			velocity.x += acceleration*delta*0.1
			if velocity.x > -1:
				velocity.x = 0

# warning-ignore:unused_argument
func attack_state(delta):
	sparkle_particle()
	dash = false
# warning-ignore:return_value_discarded
	move_and_slide(Vector2.ZERO)
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		smoke_puff()
	if not (last_input < 0 or abs(rotation_degrees) > 90) and not (last_input < 0 and abs(rotation_degrees) > 90):
		velocity = velocity.move_toward(Vector2(rad2deg(cos(rotation_degrees)), rad2deg(sin(rotation_degrees)))*max_speed*0.05, delta*acceleration*5)
	else:
		velocity = velocity.move_toward(Vector2(rad2deg(cos(rotation_degrees)), rad2deg(sin(rotation_degrees)))*max_speed*-0.05, delta*acceleration*5)
	input = 0
	animation_player.play('attack')

func attack_ended():
	state = MOVE

func process_gravity(delta):#Called every frame to simulate gravity
# warning-ignore:return_value_discarded
	if not on_ground() and not state == ATTACK:#If we are floating
		velocity.y += 200*delta#apply a downwards force and put delta in ther for fairness.

func on_ground() -> bool:
# warning-ignore:return_value_discarded
	move_and_slide(Vector2.ZERO, Vector2.UP)#Update the next function
	return is_on_floor()

func smoke_puff():
	var effect = smoke.instance()
	get_parent().add_child(effect)
	effect.emitting = true
	effect.global_position = Vector2(global_position.x, global_position.y+2)

func sparkle_particle():
	var effect = sparkle.instance()
	get_parent().add_child(effect)
	effect.emitting = true
	effect.global_position = Vector2(global_position.x, global_position.y)
	effect.rotation_degrees = rotation_degrees
