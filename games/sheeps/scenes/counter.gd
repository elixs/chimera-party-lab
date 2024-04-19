extends PanelContainer

@onready var label: Label = $MarginContainer/Label
var game_ended = false

var data: PlayerData:
	set(value):
		data = value
		if is_node_ready():
			_update()
var count: int = 0


func _ready() -> void:
	_update()


func _input(event: InputEvent) -> void:
	if not data:
		return
	if event.is_action_pressed("action_a_%d" % data.input):
		if not game_ended:
			count += 1
		_shake()


func show_count() -> void:
	label.text = str(count)


func _shake() -> void:
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
func _update() -> void:
	if not data:
		return
	self_modulate = data.primary_color
	self_modulate.a = 0.9
