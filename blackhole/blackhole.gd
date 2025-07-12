extends RigidBody2D

@onready var line_2d: Line2D = $"../Drag Indiactor Line"
@export var impulse_strength: float = 100.0
var drag_origin: Vector2
var max_distance: float = 300.0

func _ready():
	# Set up the Line2D properties
	line_2d.width = 5.0
	line_2d.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line_2d.end_cap_mode = Line2D.LINE_CAP_ROUND
	line_2d.joint_mode = Line2D.LINE_JOINT_ROUND
	line_2d.default_color = Color.WHITE

func _on_drag_start(drag_origin: Vector2) -> void:
	line_2d.clear_points()
	line_2d.add_point(drag_origin)
	line_2d.add_point(drag_origin) 
	line_2d.default_color = Color.WHITE

func _on_launch(_drag_origin: Vector2, _drag_end: Vector2, _distance: float) -> void:
	var drag_origin = global_position
	var drag_position = get_global_mouse_position()
	var distance = drag_origin.distance_to(drag_position)
	var clamped_distance = min(distance, max_distance)
	line_2d.clear_points()
	
	var drag_direction = (drag_position - global_position).normalized()
	var impulse_direction = -drag_direction  # Opposite direction for launch
	var impulse_magnitude = (clamped_distance / max_distance) * impulse_strength
	
	var impulse = impulse_direction * impulse_magnitude
	self.apply_central_impulse(impulse)

func _handle_drag(_drag_origin: Vector2, _drag_position: Vector2, _distance: float) -> void:
	var drag_origin = global_position
	var drag_position = get_global_mouse_position()
	var distance = drag_origin.distance_to(drag_position)
	var clamped_distance = min(distance, max_distance)
	var drag_direction = (drag_position - global_position).normalized()
	var final_position = drag_origin + drag_direction * clamped_distance
	
	line_2d.clear_points()
	line_2d.add_point(global_position)
	line_2d.add_point(final_position)
	
	var color_progress = clamped_distance / max_distance
	
	var line_color = Color.WHITE.lerp(Color.RED, color_progress)
	line_2d.default_color = line_color
	
