extends RigidBody2D

func _ready() -> void:
	constant_force.x = randf_range(-600, -300)


func _on_timer_timeout() -> void:
	constant_force.x *= 1.125
