extends Node3D



@export_group("line")
@export var max_line_length: float = 5.0
@export var max_speed_for_color: float = 10.0

@export_group("color")
@export var use_color_for_speed: bool = true
@export var default_color: Color = Color.CYAN
@export var min_color: Color = Color.WHITE
@export var max_color: Color = Color.RED

func draw_velocity_line(velocity, immediate_mesh, max_speed):
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
		var speed_ratio = clamp(speed / max_speed, 0.0, 1.0)
		line_color = min_color.lerp(max_color, speed_ratio)
	else:
		var line_length = clamp(speed, 0.1, max_line_length)
		end_pos = start_pos + direction * line_length
		line_color = default_color
	
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	immediate_mesh.surface_set_color(line_color)
	immediate_mesh.surface_add_vertex(start_pos)
	
	immediate_mesh.surface_set_color(line_color)
	immediate_mesh.surface_add_vertex(end_pos)
	
	immediate_mesh.surface_end()
