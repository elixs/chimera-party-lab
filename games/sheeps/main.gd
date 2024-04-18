extends Node2D

const sheep_scene = preload("res://games/sheeps/scenes/sheep.tscn")
const counter_scene = preload("res://games/sheeps/scenes/counter.tscn")


@onready var players: Node2D = $Players
@onready var sheeps: Node2D = $Sheeps
@onready var spawns: Node2D = $Spawns
@onready var game_timer: Timer = $GameTimer
@onready var counter_container: HBoxContainer = %CounterContainer



func _ready() -> void:
	for i in Game.players.size():
		var player_data = Game.players[i]
		var counter_inst = counter_scene.instantiate()
		counter_container.add_child(counter_inst)
		counter_inst.data = player_data
		#var player_inst = player_scene.instantiate() as Chimerin
		#player_inst.global_position = spawns.get_child(i).global_position
		#players.add_child(player_inst)
		#player_inst.setup(player_data)
		
		#var hbox = HBoxContainer.new()
		#var color_rect = ColorRect.new()
		#color_rect.custom_minimum_size = Vector2.ONE * 100
		#color_rect.color = player_data.primary_color
		#hbox.add_child(color_rect)
		#var label = Label.new()
		#hbox.add_child(label)
		#label.text = str(player_data.local_score)
		#score_container.add_child(hbox)
	
	game_timer.timeout.connect(_on_game_ended)
	_spawn_sheeps()


#func _process(delta: float) -> void:
	#for i in Game.players.size():
		#var player_data = Game.players[i]
		#var label = score_container.get_child(i).get_child(1) as Label
		#label.text = str(player_data.local_score)



func _spawn_sheep() -> Node2D:
	var sheep_inst = sheep_scene.instantiate()
	sheep_inst.global_position = Vector2(1920 + randf_range(50, 100), 380 + randf_range(-300, 300))
	sheeps.add_child(sheep_inst)
	return sheep_inst


func _spawn_sheeps() -> void:
	var sheep_amount = randi_range(20, 40)
	for i in sheep_amount:
		_spawn_sheep()
		await get_tree().create_timer(randf_range(0.5,1.5)).timeout


func _on_game_ended():
	for child in counter_container.get_children():
		child.show_count()
	await get_tree().create_timer(3).timeout
	Game.end_game()
