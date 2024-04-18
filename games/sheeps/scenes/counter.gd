extends PanelContainer

@onready var label: Label = $MarginContainer/Label

var data: PlayerData
var count: int = 0


func _input(event: InputEvent) -> void:
	if not data:
		return
	if event.is_action_pressed("action_a_%d" % data.input):
		count += 1
		_shake()


func show_count() -> void:
	label.text = str(count)


func _shake() -> void:
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	
