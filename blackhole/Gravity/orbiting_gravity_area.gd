extends Area3D

@onready var bodies = []
var orbital_speed: float = 1000 # Adjustable orbital speed

func _physics_process(delta: float) -> void:
	for body in bodies:
		if is_instance_valid(body):
			# Get the vector from this Area3D to the orbiting body
			var direction = body.global_position - global_position
			var distance = direction.length()
			
			# Normalize the direction vector
			direction = direction.normalized()
			
			# Create a perpendicular vector for orbital motion
			# We'll rotate around the Y-axis (you can change this for different orbital planes)
			var orbital_direction = Vector3(-direction.z, 0, direction.x).normalized()
			
			# Calculate orbital velocity based on distance and speed
			var orbital_velocity = orbital_direction * orbital_speed * delta
			
			# Update the body's position
			body.linear_velocity = orbital_velocity

func _on_body_entered(body: Node3D) -> void:
	if body not in bodies:
		if body == get_parent():
			return
		elif body is MainPlayerRigidBody:
			#ignore the player, send particles to him
			return
		bodies.append(body)
		
		#print("Body entered orbit: ", body.name)

func _on_body_exited(body: Node3D) -> void:
	if body in bodies:
		bodies.erase(body)
		#print("Body left orbit: ", body.name)

func _ready():
	# Connect the signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
