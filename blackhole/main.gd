extends Node2D

@onready var blackhole: RigidBody2D = $Blackhole
@onready var sprite_2d: Sprite2D = $Sprite2D
var shader_material: ShaderMaterial

func _ready():
	shader_material = sprite_2d.material as ShaderMaterial

func _process(_delta):
	if blackhole and shader_material:
		# Get the blackhole's position
		var blackhole_pos = blackhole.global_position
		
		# Convert to normalized coordinates for parallax effect
		# Scale down the movement for slower parallax (adjust these values as needed)
		var parallax_factor = 0.0001  # Lower values = slower parallax
		var normalized_pos = Vector2(
			blackhole_pos.x * parallax_factor,
			blackhole_pos.y * parallax_factor
		)
		
		# Update the shader parameter
		shader_material.set_shader_parameter("mouse", normalized_pos) 
