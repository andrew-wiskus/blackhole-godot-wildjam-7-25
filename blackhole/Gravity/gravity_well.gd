class_name GravityWell2D
extends Area2D

## Strength of the gravitational pull
@export var gravity_force: float = 500.0

## Maximum distance at which gravity is applied
@export var max_distance: float = 500.0

## Whether to use inverse square law (realistic gravity) or linear falloff
@export var use_inverse_square_law: bool = true

## Group name for objects that can be affected by this gravity well
@export var affected_group: String = "grabbable"

func _ready() -> void:
	# Connect the signal for bodies entering the area
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	


# List of bodies currently affected by gravity
var affected_bodies: Array[PhysicsBody2D] = []

func _on_body_entered(body: Node2D) -> void:
	if body is PhysicsBody2D and body.is_in_group(affected_group):
		if not affected_bodies.has(body):
			affected_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if affected_bodies.has(body):
		affected_bodies.erase(body)

func _physics_process(delta: float) -> void:
	for body in affected_bodies:
		if is_instance_valid(body):
			var direction = global_position - body.global_position
			var distance = direction.length()
			
			# Skip if we're at the center to avoid division by zero
			if distance < 0.1:
				continue
				
			# Calculate force based on distance
			var force_magnitude: float
			if use_inverse_square_law:
				# Inverse square law (realistic gravity)
				force_magnitude = gravity_force / (distance * distance/10000)
				# Prevent extreme forces when very close
				force_magnitude = min(force_magnitude, gravity_force * 10)
			else:
				# Linear falloff
				force_magnitude = gravity_force * (1.0 - distance / max_distance)
				
			# Only apply force if within max_distance
			if distance <= max_distance:
				direction = direction.normalized()
				var force = direction * force_magnitude * delta
				
				if body is RigidBody2D:
					body.apply_central_force(force)
				else:
					# For other physics bodies, try to move them directly
					body.global_position += force * delta
