extends RigidBody3D

@onready var target_position: Node3D = $"../Target Position"



func _ready() -> void:
	self.linear_damp = 0
	self.angular_damp = 0
	var drag_origin = target_position.global_position
	var drag_position = global_position
	var distance = drag_origin.distance_to(drag_position)
	
	var drag_direction = (drag_origin - drag_position).normalized()
	var impulse_direction = drag_direction  # Opposite direction for launch
	var impulse_magnitude = 50
	
	var impulse = impulse_direction * impulse_magnitude
	self.apply_central_impulse(impulse)
