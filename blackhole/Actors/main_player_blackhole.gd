class_name MainPlayerRigidBody
extends RigidBody3D
@export_group("Movement")
@export var force_multiplier = 5
@export var drag_coefficient = 1
@export var max_speed = 100

@export_group("directional_line")
@export var show_velocity_line: bool = true
@export var use_color_for_speed: bool = true
@export var max_line_length: float = 5.0
@export var max_speed_for_color: float = 10.0
@export var min_color: Color = Color.GREEN
@export var max_color: Color = Color.RED

@onready var camera = $Main_Player_Camera

var debug_mesh_instance: MeshInstance3D
var immediate_mesh: ImmediateMesh
var general_size_holder

@export_group("size")
@export var general_size: float = 1.0

@export_group("consuming")
@export var camera_distancing_step: float = 0.0001
@export var initial_gravity = 9.8

func _ready() -> void:
	
	general_size_holder = general_size
	initialize_sizes(general_size)
	
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
	# Get transformed direction vectors
	# Convert rotation in degrees to radians
	#var rotation_rad = rotation * PI / 180.0

	# Create a basis from Euler angles (in radians)
	var basis = Basis.from_euler(rotation)

	# Get transformed direction vectors
	var forward = basis * Vector3.FORWARD
	var left = basis * Vector3.LEFT
	var up = basis * Vector3.UP

	var f = (forward*forward_back + left*left_right + up*up_down)*force_multiplier

	#constant_force = (Vector3.FORWARD*forward_back + Vector3.LEFT*left_right + Vector3.UP*up_down)*force_multiplier 
	constant_force = f*force_multiplier
	
	if show_velocity_line:
		draw_velocity_line()
	
	if general_size != general_size_holder:
		general_size_holder = general_size
		update_size(general_size)
func draw_velocity_line():
	var velocity = linear_velocity
	var speed = velocity.length()
	
	if speed < 0.01:
		immediate_mesh.clear_surfaces()
		return
	
	var direction = velocity.normalized()
	var start_pos = Vector3.ZERO  # Relative to this object
	
	var end_pos: Vector3
	var line_color: Color
	
	if use_color_for_speed:
		end_pos = start_pos + direction * max_line_length
		var speed_ratio = clamp(speed / max_speed_for_color, 0.0, 1.0)
		line_color = min_color.lerp(max_color, speed_ratio)
	else:
		var line_length = clamp(speed, 0.1, max_line_length)
		end_pos = start_pos + direction * line_length
		line_color = Color.CYAN
	
	# Clear and rebuild mesh
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# Add line vertices
	immediate_mesh.surface_set_color(line_color)
	immediate_mesh.surface_add_vertex(start_pos)
	immediate_mesh.surface_set_color(line_color)
	immediate_mesh.surface_add_vertex(end_pos)
	
	immediate_mesh.surface_end()


func _on_detectable_inner_radius_body_entered(body: Node3D) -> void:
	if body == $".":
		pass
	else:
		# check if body is larger
		if body.general_size <= general_size:
			increase_size(0.01)
			increase_move_speed(0.001)
			$Main_Player_Camera.zoom()
			body.queue_free()
		else:
			print("You died")
			
	pass # Replace with function body.


func initialize_sizes(size):
	$"Blackhole Animated Sprite".scale  = Vector3.ONE*size
	$CollisionShape3D.scale = Vector3.ONE*size
	$Rigid_Body_Gravity_Area/CollisionShape3D.scale =  Vector3.ONE*size
	$"Detectable Inner Radius/CollisionShape3D".scale =  Vector3.ONE*size

func update_size(size):
	$"Blackhole Animated Sprite".scale  = Vector3.ONE*size
	$CollisionShape3D.scale = Vector3.ONE*size
	$Rigid_Body_Gravity_Area/CollisionShape3D.scale =  Vector3.ONE*size
	$"Detectable Inner Radius/CollisionShape3D".scale =  Vector3.ONE*size
func _on_rigid_body_gravity_area_area_entered(area: Area3D) -> void:
	print(area)
	pass # Replace with function body.


func _on_rigid_body_gravity_area_body_entered(body: Node3D) -> void:
	print(body)
	pass # Replace with function body.

#FOR SWIZZY: Shop Upgrade functions
func increase_gravity(step):
	$"Rigid_Body_Gravity_Area".gravity += step
func increase_move_speed(step):
	force_multiplier += step
func increase_size(step):
	general_size += step
