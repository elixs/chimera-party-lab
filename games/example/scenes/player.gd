extends Button


@onready var pc: PlayerController = $PlayerController

func _ready() -> void:
	pressed.connect(_on_pressed)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(pc.action_a):
		pressed.emit()


func setup(player_data: PlayerData) -> void:
	pc.setup(player_data, on_color_changed)


func on_color_changed(color: Color) -> void:
	modulate = color


func _on_pressed() -> void:
	pc.data.local_score += 1
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 2, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
