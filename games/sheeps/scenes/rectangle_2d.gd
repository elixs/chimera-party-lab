@tool
extends Node2D

@export var size: Vector2

@export var rectange: RectangleShape2D


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	rectange.draw(get_canvas_item(), Color.CYAN)
