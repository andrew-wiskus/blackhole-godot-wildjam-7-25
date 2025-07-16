class_name MainPlayerRigidBody
extends RigidBody3D
@export_group("Movement")
@export var initial_force_multiplier = 5.0
@export var drag_coefficient = 1.0
@export var max_speed = 100.0


@onready var camera = $Main_Player_Camera
@onready var debug_velocity_line = $DebugVelocityLine
@export var show_velocity_line: bool = false

var debug_mesh_instance: MeshInstance3D
var immediate_mesh: ImmediateMesh
var force_multiplier = initial_force_multiplier

@export_group("size")
@export var initial_size: float = 1.0
var general_size: float = initial_size

@export_group("consuming")
@export var camera_distancing_step: float = 0.0001
@export var initial_gravity = 10

func _ready() -> void:
	_update_components_for_size(initial_size)
	
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

func _physics_process(delta: float):
	var forward_back = Input.get_axis("S", "W")
	var left_right = Input.get_axis("D", "A")
	var up_down = Input.get_axis("C", "Space")

	# Create a basis from Euler angles (in radians)
	var basis = Basis.from_euler(rotation)
	var forward = basis * Vector3.FORWARD
	var left = basis * Vector3.LEFT
	var up = basis * Vector3.UP

	var f = (forward * forward_back + left * left_right + up * up_down) * force_multiplier
	constant_force = f * force_multiplier # multiplying by force_multiplier twice? o.o
	if show_velocity_line:
		debug_velocity_line.draw_velocity_line(linear_velocity, immediate_mesh, 100.0)

func _on_detectable_inner_radius_body_entered(body: Node3D) -> void: # on CONSUME :D
	if body == $".":
		return
	
	if body.general_size <= general_size:
		GameState.on_consume_increase_currency(body.general_size)
		body.queue_free()
	else:
		print("You died")

func _update_components_for_size(size):
	general_size = size
	$"Blackhole Animated Sprite".scale  = Vector3.ONE * size
	$CollisionShape3D.scale = Vector3.ONE * size
	$Rigid_Body_Gravity_Area/CollisionShape3D.scale = Vector3.ONE * size
	$"Detectable Inner Radius/CollisionShape3D".scale = Vector3.ONE * size
	
func set_gravity_multiplier(multiplier):
	$"Rigid_Body_Gravity_Area".gravity = initial_gravity * multiplier

func set_movement_multiplier(multiplier):
	force_multiplier = initial_force_multiplier * multiplier

func set_player_size_multiplier(multiplier):
	_update_components_for_size(initial_size * multiplier)
	
