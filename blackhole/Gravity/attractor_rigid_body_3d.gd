extends RigidBody3D
@export_group("Movement")
@export var force_multiplier = 5

@export_group("directional_line")
@export var show_velocity_line: bool = true
@export var use_color_for_speed: bool = true
@export var max_line_length: float = 5.0
@export var max_speed_for_color: float = 10.0
@export var min_color: Color = Color.GREEN
@export var max_color: Color = Color.RED


var debug_mesh_instance: MeshInstance3D
var immediate_mesh: ImmediateMesh


@export_group("size")
@export var general_size: float = 1.0

func _ready() -> void:
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
func _on_body_entered(body: Node) -> void:
	if body is GPUParticles3D:
		print("entered GPUParticles")
		print(body)
	pass # Replace with function body.
func _physics_process(delta: float):
	var forward_back =  Input.get_axis("S", "W")
	var left_right =  Input.get_axis("D", "A")
	var f = (Vector3.FORWARD*forward_back + Vector3.LEFT*left_right)*force_multiplier
	constant_force = f
	
	if show_velocity_line:
		draw_velocity_line()

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
			body.queue_free()
		else:
			game_end()
			
	pass # Replace with function body.
func game_end():
	#you died here: write code for it
	print("you die here, write code for it")
func update_size(size:Vector3):
	$Sprite3D.scale = size
	$CollisionShape3D.scale = size
	$Area3D/CollisionShape3D.scale =  size
func increase_size(step:Vector3):
	$Sprite3D.scale += step
	$CollisionShape3D.scale += step
	$Area3D/CollisionShape3D.scale +=  step		
