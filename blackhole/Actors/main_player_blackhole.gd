class_name MainPlayerRigidBody
extends RigidBody3D

@export var spawn_at_origin = true

@export_group("Movement")
@export var initial_force_multiplier = 5.0
@export var drag_coefficient = 1.0
@export var max_speed = 100.0


@onready var camera = $Main_Player_Camera_ORTHO
@onready var debug_velocity_line = $DebugVelocityLine
@export var show_velocity_line: bool = false

var debug_mesh_instance: MeshInstance3D
var immediate_mesh: ImmediateMesh
@onready var force_multiplier = initial_force_multiplier

@export_group("size")
@export var initial_size: float = 1.0
@onready var general_size: float = initial_size

@export_group("consuming")
@export var camera_distancing_step: float = 0.0001
@export var initial_gravity = 10
@export var initial_passive_mass = 1

@onready var _passive_mass = initial_passive_mass
@onready var _initial_gpu_attractr_gravity = $GPUParticlesAttractorSphere3D.strength
@onready var debug_sphere = $"Blackhole Animated Sprite/EDITOR_DEBUG_SPHERE"
var _audio_controller: AudioController

func _ready() -> void:
	_update_components_for_size(initial_size)
	$"Rigid_Body_Gravity_Area".gravity = initial_gravity
	linear_velocity.x = 1
	
	# Create debug mesh instance for directional line
	debug_mesh_instance = MeshInstance3D.new()
	add_child(debug_mesh_instance)
	
	immediate_mesh = ImmediateMesh.new()
	debug_mesh_instance.mesh = immediate_mesh
	
	# Create unshaded material
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	debug_mesh_instance.material_override = material
	
	# spawn at 0,0 grid cord
	if spawn_at_origin:
		global_position = Vector3(0, global_position.y, 0)
		
	#debug_sphere.hide()
	_audio_controller = get_tree().get_first_node_in_group("audio_controller")

func _physics_process(delta: float):
	var forward_back = Input.get_axis("S", "W")
	var left_right = Input.get_axis("D", "A")
	var up_down = Input.get_axis("C", "Space")

	# Create a basis from Euler angles (in radians)
	var basis = Basis.from_euler(Vector3.ZERO)
	var forward = basis * Vector3.FORWARD
	var left = basis * Vector3.LEFT
	var up = basis * Vector3.UP

	var f = (forward * forward_back + left * left_right + up * up_down) * force_multiplier
	constant_force = f
	if show_velocity_line:
		debug_velocity_line.draw_velocity_line(linear_velocity, immediate_mesh, 100.0)

func _on_detectable_inner_radius_body_entered(body) -> void: # on CONSUME :D
	pass

func _update_components_for_size(size):
	general_size = size
	$"Blackhole Animated Sprite".scale  = Vector3.ONE * size
	$CollisionShape3D.scale = Vector3.ONE * size
	$Rigid_Body_Gravity_Area/CollisionShape3D.scale = Vector3.ONE * size
	#$"Detectable Inner Radius/CollisionShape3D".scale = Vector3.ONE * size
	$GPUParticlesAttractorSphere3D.scale = Vector3.ONE * size
	$GPUParticlesCollisionSphere3D.scale = Vector3.ONE * size
	$GPUParticles3D.multiplier_particle_size(size)
func set_gravity_multiplier(multiplier):
	$"Rigid_Body_Gravity_Area".gravity = initial_gravity * multiplier
	$GPUParticlesAttractorSphere3D.strength = _initial_gpu_attractr_gravity*multiplier

func set_movement_multiplier(multiplier):
	force_multiplier = initial_force_multiplier * multiplier

func set_player_size_multiplier(multiplier):
	_update_components_for_size(initial_size * multiplier)

func set_passive_mass(multiplier):
	_passive_mass = initial_passive_mass*multiplier

func _on_rigid_body_gravity_area_body_entered(body: RigidBody3D) -> void:
		body.linear_velocity.x = 0.1

#func start_particle_animation(body):
	#var animation = preload("res://Assets/Particles/surface particles.tscn").instantiate()

func _spawn_floating_number_go_up(value):
		var scene = preload("res://number_go_up_particle.tscn")
		var number_go_up_particle := scene.instantiate() as NumberGoUpParticle
		add_child(number_go_up_particle)
		number_go_up_particle.set_label_values(int(value))
		number_go_up_particle.global_position = global_position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		_spawn_floating_number_go_up(2000)

		


func _on_passive_mass_timer_timeout() -> void:
	GameState.on_consume_increase_currency(_passive_mass)
	pass # Replace with function body.
