# rotate_sprite.gd
extends AnimatedSprite3D

@export var SPEED: float = 90.0  # Degrees per second

func _process(delta: float) -> void:
	rotation_degrees.z += -SPEED * delta
