extends Area2D
@export var radius = 150

func _ready() -> void:
	# Original shape is shared
	var original_shape = $CollisionShape2D.shape

	# Create a unique copy
	var unique_shape = CircleShape2D.new()
	unique_shape.radius = original_shape.radius  # Copy properties

	# Assign the unique shape
	$CollisionShape2D.shape = unique_shape
