class_name ConsumeableObject extends RigidBody3D

@export var custom_size: float = 0.0
@export var use_custom_sprite: bool = false
@export var particles: GPUParticles3D

@onready var _gravity_area_3d = $GravityArea3D
@onready var _gravity_collision_shape = $GravityArea3D/CollisionShape3D
@onready var _collision_detector = $CollisionShape3D
@onready var _sprite = $"Sprite3D"

var type: CC.ConsumableType = CC.ConsumableType.NOT_SET
var general_size 

func _ready() -> void:
	_collision_detector.shape = _collision_detector.shape.duplicate()
	_gravity_collision_shape.shape = _gravity_collision_shape.shape.duplicate()
	if custom_size > 0.0: set_size(custom_size)
	

func init(
		type_id: CC.ConsumableType, 
		grav_str: float, 
		size_value: float, 
		texture: Texture2D, 
		velocity_direction: Vector3, 
		velocity_mag: float, 
		spin_direction: Vector3, 
		spin_speed: float,
	):
	
	type = type_id
	_gravity_area_3d.gravity = grav_str
	set_size(custom_size if custom_size > 0.0 else size_value)
	if use_custom_sprite != true:
		_sprite.texture = texture
	

	linear_velocity = velocity_direction * velocity_mag
	angular_velocity = spin_direction * spin_speed
	rotation = Vector3(0, 0, 0)


func set_size(to_size): # set to 20.0
	general_size = to_size
	_collision_detector.scale = Vector3.ONE * general_size
	_gravity_collision_shape.scale = Vector3.ONE * general_size
	_sprite.scale = Vector3.ONE * general_size
	if particles:
		particles.multiplier_particle_size(to_size)
	if has_node("Player_Vicinity_Check"):
		$Player_Vicinity_Check.get_child(0).scale = Vector3.ONE * general_size
func set_size_multiplier(multi): # increase by 2.0x
	var new_size = general_size * multi
	set_size(new_size)
