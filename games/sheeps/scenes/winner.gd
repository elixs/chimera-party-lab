extends PanelContainer


@export var color: Color:
	set(value):
		color = value
		if is_node_ready():
			_update()
@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	_update()


func _update() -> void:
	color_rect.color = color
