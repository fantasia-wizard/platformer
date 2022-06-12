extends Node

var max_health = 4
var health = max_health
var coins = 0
var dead = false
var position_x = 56
var position_y = 24
var position = Vector2(position_x, position_y)
var coins_collected = []
var buttons = true
var scene = ''

func _ready():
	load_game()

func save():
	var save_game = {
		'max_health' : max_health,
		'health' : health,
		'coins' : coins,
		'position_x' : position_x,
		'position_y' : position_y,
		'coins_collected' : coins_collected,
		'buttons' : buttons,
		'scene' : scene
	}
	return save_game

func save_game():
	position_x = position.x
	position_y = position.y
	var save_game = File.new()
	save_game.open('user://savegame.save', File.WRITE)
	var data = save()
	save_game.store_line(to_json(data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists('user://savegame.save'):
		return
	save_game.open('user://savegame.save', File.READ)
	while save_game.get_position() < save_game.get_len():
		var data = parse_json(save_game.get_line())
		for i in data.keys():
			set(i, data[i])
		position = Vector2(position_x, position_y)
		change_scene(scene)
	save_game.close()

func reset():
	max_health = 4
	health = max_health
	coins = 0
	dead = false
	position_x = 56
	position_y = 24
	position = Vector2(position_x, position_y)
	coins_collected = []
	save_game()
# warning-ignore:return_value_discarded
	change_scene('res://levels/overworld/world_1.tscn')

func _process(_delta):
	save_game()

func change_scene(new_scene: String):
# warning-ignore:return_value_discarded
	get_tree().change_scene(new_scene)
	scene = new_scene
