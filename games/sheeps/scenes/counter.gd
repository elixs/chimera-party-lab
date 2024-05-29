extends PanelContainer

@export var click_scene: PackedScene
var game_ended = false
@onready var label: Label = $MarginContainer/Label
@onready var pc: PlayerController = $PlayerController


var count: int = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(pc.action_a):
		if not game_ended:
			count += 1
		_shake()
		_click()


func setup(player_data: PlayerData) -> void:
	pc.setup(player_data, change_color)


func change_color(color: Color) -> void:
	self_modulate = color
	self_modulate.a = 0.9


func show_count() -> void:
	label.text = str(count)


func _shake() -> void:
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	



func _click() -> void:
	if not click_scene:
		return
	var click_inst = click_scene.instantiate()
	add_child(click_inst)
