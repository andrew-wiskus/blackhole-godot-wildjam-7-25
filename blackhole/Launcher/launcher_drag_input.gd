class_name GridDragDrop extends Node2D

signal on_drag_start(entity: GridDragDrop)
signal on_drop(entity: GridDragDrop, at_position: Vector2)
signal on_click()

@export var drag_distance_threshold: float = 5

# origin of the drag
var _original_position: Vector2
var _original_z_index: int
var _start_drag_mouse_offset: Vector2 = Vector2.ZERO
var _drag_distance: float = 0.0
var parent_node: Node2D

# target position of the drag
var _target_position: Vector2 = Vector2.ZERO

var is_dragging: bool = false

func _ready() -> void:
	get_node("ClickArea").input_event.connect(_on_click_area_input_event)
	parent_node = get_parent()

func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true

	_original_position = parent_node.global_position
	_start_drag_mouse_offset = Vector2(mouse_pos - _original_position)
	_original_z_index = z_index
	
	z_index = 100
	on_drag_start.emit(self)

func _end_drag() -> void:
	if not is_dragging:
		return
		
	is_dragging = false
	z_index = _original_z_index
	
	if _drag_distance < drag_distance_threshold:
		_target_position = _original_position
		_handle_click()
	else:
		var drop_position = get_global_mouse_position() # TODO: probably want to add some extra based on velocity (position_dif * time)
		on_drop.emit(self, drop_position)
	

func _process(_delta: float) -> void:
	if _target_position != Vector2.ZERO:
		var speed = 5000
		parent_node.global_position = parent_node.global_position.move_toward(_target_position, speed * _delta)
	
	# Check for global mouse button release to end drag
	if is_dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_end_drag()
	
	if is_dragging:
		_target_position = get_global_mouse_position()
		_drag_distance = _original_position.distance_to(_target_position)

func _on_click_area_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_start_drag(event.global_position)

func _handle_click() -> void:
	on_click.emit(self)
