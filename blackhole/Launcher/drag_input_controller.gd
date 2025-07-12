class_name DragInputController extends Area2D

signal on_drag_start(drag_origin: Vector2)
signal on_drop(drag_origin: Vector2, drag_position: Vector2, distance: float)
signal handle_drag(drag_origin: Vector2, drag_position: Vector2, distance: float)

@export var drag_distance_threshold: float = 0

# origin of the drag
var _original_position: Vector2
var _start_drag_mouse_offset: Vector2 = Vector2.ZERO
var _drag_distance: float = 0.0
var parent_node: Node2D

# target position of the drag
var _target_position: Vector2 = Vector2.ZERO

var is_dragging: bool = false

func _ready() -> void:
	input_event.connect(_on_click_area_input_event)
	parent_node = get_parent()

func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true

	_original_position = parent_node.global_position
	_start_drag_mouse_offset = Vector2(mouse_pos - _original_position)
	
	z_index = 100
	on_drag_start.emit(self)

func _end_drag() -> void:
	if not is_dragging:
		return
		
	is_dragging = false
	
	if _drag_distance < drag_distance_threshold:
		_handle_click()
	else:
		var drag_position: Vector2 = get_global_mouse_position() # can limit its max-pull radius here
		var distance = _original_position.distance_to(drag_position)
		on_drop.emit(_original_position, drag_position, distance)

func _process(_delta: float) -> void:
	# Check for global mouse button release to end drag
	if is_dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_end_drag()
		return
	
	if is_dragging:
		var drag_position: Vector2 = get_global_mouse_position() # can limit its max-pull radius here
		var distance = _original_position.distance_to(drag_position)
		handle_drag.emit(_original_position, drag_position, distance)

func _on_click_area_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_start_drag(event.global_position)

func _handle_click():
	pass
