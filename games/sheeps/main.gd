extends Node2D



@export var sheep_scene: PackedScene
@export var counter_scene: PackedScene
@export var sheep_ball_scene: PackedScene
@export var winner_scene: PackedScene
var _sheep_amount: int
var _sheeps_killed: int
var _sheep_balls: Array = []
var _results_shown = false
@onready var players: Node2D = $Players
@onready var sheeps: Node2D = $Sheeps
@onready var spawns: Node2D = $Spawns
@onready var counter_container: HBoxContainer = %CounterContainer
@onready var spawn_top: Marker2D = %SpawnTop
@onready var spawn_bottom: Marker2D = %SpawnBottom
@onready var kill_zone: Area2D = $KillZone
@onready var game_over_timer: Timer = $GameOverTimer
@onready var camera_game: Marker2D = %CameraGame
@onready var camera_results: Marker2D = %CameraResults
@onready var camera_2d: Camera2D = $Camera2D
@onready var results: Label = %Results
@onready var spawn_left: Marker2D = %SpawnLeft
@onready var spawn_right: Marker2D = %SpawnRight
@onready var sheep_balls: Node2D = %SheepBalls
@onready var results_area: Area2D = $Fence/ResultsArea
@onready var winner_label: Label = %WinnerLabel
@onready var winners_container: HBoxContainer = %WinnersContainer


func _ready() -> void:
	camera_2d.global_position = camera_game.global_position
	winner_label.hide()
	if counter_scene:
		for i in Game.players.size():
			var player_data = Game.players[i]
			var counter_inst = counter_scene.instantiate()
			counter_container.add_child(counter_inst)
			counter_inst.setup(player_data)

	kill_zone.body_entered.connect(_on_sheep_entered)
	results_area.body_entered.connect(_on_sheep_ball_entered)
	game_over_timer.timeout.connect(_show_results)
	_spawn_sheeps()


func _spawn_sheep() -> Node2D:
	var sheep_inst = sheep_scene.instantiate()
	sheep_inst.global_position = Vector2(
		spawn_top.global_position.x + randf_range(-300, 300),
		randf_range(spawn_top.global_position.y, spawn_bottom.global_position.y)
	)
	sheeps.add_child(sheep_inst)
	return sheep_inst


func _spawn_sheeps() -> void:
	_sheep_amount = randi_range(40, 60)
	var _sheeps_remaining = _sheep_amount
	#Debug.log(_sheep_amount)
	while _sheeps_remaining > 0:
		var sheeps = randi() % 3
		sheeps = min(sheeps, _sheeps_remaining)
		_sheeps_remaining -= sheeps
		for i in sheeps:
			_spawn_sheep()
		await get_tree().create_timer(randf_range(0.1,0.3)).timeout


func _on_sheep_entered(body: Node2D) -> void:
	body.queue_free()
	_sheeps_killed += 1
	game_over_timer.start()
	if _sheeps_killed == _sheep_amount:
		_show_results()


func _show_results() -> void:
	if _results_shown:
		return
	_results_shown = true
	
	for counter in counter_container.get_children():
		counter.game_ended = true
	
	# TODO play sound
	for counter in counter_container.get_children():
		counter.show_count()
		# TODO play sound
		await get_tree().create_timer(0.3).timeout
	
	var tween = create_tween()
	tween.tween_property(camera_2d, "global_position", camera_results.global_position, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await _spawn_sheep_balls()
	await get_tree().create_timer(2).timeout
	await _show_winner()
	await get_tree().create_timer(3).timeout
	Game.end_game()


func _spawn_sheep_ball() -> void:
	var sheep_ball_inst = sheep_ball_scene.instantiate()
	sheep_balls.add_child(sheep_ball_inst)
	sheep_ball_inst.global_position = Vector2(
		randf_range(spawn_left.global_position.x, spawn_right.global_position.x),
		spawn_left.global_position.y + randf_range(-100, 100)
	)


func _spawn_sheep_balls() -> void:
	for i in _sheep_amount:
		_spawn_sheep_ball()
		await get_tree().create_timer(randf_range(0.1,0.2)).timeout


func _on_sheep_ball_entered(body: Node2D) -> void:
	if body not in _sheep_balls:
		_sheep_balls.push_back(body)
		results.text = str(_sheep_balls.size())


func _show_winner() -> void:
	var diff = _sheep_amount
	var winners = []
	for counter in counter_container.get_children():
		var player_diff = abs(counter.count - _sheep_amount)
		if player_diff < diff:
			winners = [counter.pc.data]
			diff = player_diff
		elif player_diff == diff:
			winners.push_back(counter.pc.data)
	if winners.size() > 1:
		winner_label.text += "s"
	winner_label.show()
	# TODO play sound
	await get_tree().create_timer(0.75).timeout
	for winner in winners:
		var winner_inst = winner_scene.instantiate()
		winner_inst.color = winner.color
		winners_container.add_child(winner_inst)
		await get_tree().create_timer(0.5).timeout
		winner.local_score = 100
		# TODO play sound
