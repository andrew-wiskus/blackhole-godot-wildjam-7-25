extends Camera3D
@export var target_node: RigidBody3D #assign this node as the parent 
@export var rotation_speed: float = 0.005
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 2.0
@export var max_zoom: float = 20.0
@export var smoothing_speed: float = 10.0  # Higher values = less smoothing
# Add these new variables for dampening
var velocity_x: float = 0.0
var velocity_y: float = 0.0
var dragging: bool = false
var radius: float

# Target rotation values for smoothing
var target_rotation_x: float = 0.0
var target_rotation_y: float = 0.0

func _ready():
	# Set initial position along z-axis
	radius = position.length()
	# Initialize target rotations with current parent rotation
	target_rotation_x = get_parent().rotation.x
	target_rotation_y = get_parent().rotation.y
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging == false:
				target_rotation_x = 0.0
				target_rotation_y = 0.0
				pass
		# Zoom with scroll wheel
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			radius = clamp(radius - zoom_speed * radius, min_zoom, max_zoom)
			position = position.normalized()*radius
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			radius = clamp(radius + zoom_speed * radius, min_zoom, max_zoom)
			position = position.normalized()*radius
	
	if event is InputEventMouseMotion and dragging:
		var rotation_x = event.relative.y * rotation_speed
		var rotation_y = event.relative.x * rotation_speed

		target_rotation_x = -rotation_x
		target_rotation_y = -rotation_y
		

func _physics_process(delta: float) -> void:
	
	# Existing smoothing code
	var current_rotation = get_parent().rotation
	
	# Smoothly interpolate current rotation to target rotation
	var new_rotation_x = lerp(current_rotation.x, target_rotation_x, smoothing_speed * delta)
	var new_rotation_y = lerp(current_rotation.y, target_rotation_y, smoothing_speed * delta)
	
	# Apply the new rotation
	get_parent().rotate_x(new_rotation_x*0.00005)
	get_parent().rotate_y(new_rotation_y*0.00005)
func zoom(size):
	
	radius = clamp(radius - zoom_speed * radius, min_zoom, max_zoom)
	position = Vector3(0, 0, radius)
