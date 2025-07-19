class_name NumberGoUpParticle extends Node3D

@onready var _label: Label3D = $"Label3D"

@export var speed = 20.0
@export var min_y = 10.0
@export var max_y = 15.0
@export var min_x = 5.0
@export var max_x = 10.0
@export var font_size = 200
@export var outline_color = Color.YELLOW
@export var inner_color = Color.BLACK

var _target_pos
var _start_pos
var _travel_height


func _ready():
	_start_pos = position
	_target_pos = position
	
	var flip = (-1 if randf() > 0.5 else 1)
	_target_pos.x += (flip * randf_range(min_x, max_x))
	
	_travel_height = randf_range(min_y, max_y)
	_target_pos.y += _travel_height

func set_label_values(value: int):
	_label.text = "+" + str(value) + "kg"
	if value <= 5.0:
		outline_color = Color.ALICE_BLUE
	elif  value <= 10.0:
		outline_color = Color.DEEP_SKY_BLUE
	else:
		outline_color = Color.YELLOW
	
	_label.outline_modulate = outline_color
	

func _process(delta: float) -> void:
	var progress = clamp((position.y - _start_pos.y) / _travel_height, 0.0, 1.0)
	
	# Ease-in curve: slow at first, fast at the end
	var eased_progress = progress * progress

	# Lerp X based on eased progress
	var arc_x_position = lerp(_start_pos.x, _target_pos.x, eased_progress)
	
	# Move toward new target that has arcing X
	var new_target = Vector3(arc_x_position, position.y + delta * speed, _target_pos.z)
	position = position.move_toward(new_target, delta * speed)
	position.z = 0.1
	if position.y >= _target_pos.y:
		queue_free()
