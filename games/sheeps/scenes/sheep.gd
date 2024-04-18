extends CharacterBody2D

var acceleration = 1000
var max_speed = 200


func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, -max_speed, acceleration * delta)
	move_and_slide()
