extends AudioStreamPlayer


func _ready() -> void:
	pitch_scale = randf_range(0.75, 1.25)

func _on_finished() -> void:
	queue_free()
