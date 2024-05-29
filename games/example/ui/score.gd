extends HBoxContainer


@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var pc: PlayerController = $PlayerController


func setup(player_data: PlayerData) -> void:
	pc.setup(player_data, on_color_changed)
	player_data.local_score_changed.connect(_update_score)


func on_color_changed(color):
	color_rect.color = color


func _update_score(value) -> void:
	label.text = str(value)
