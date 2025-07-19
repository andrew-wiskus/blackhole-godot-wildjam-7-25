class_name ConsumeableObject extends RigidBody3D

@onready var _gravity_area_3d = $GravityArea3D
@onready var _gravity_collision_shape = $GravityArea3D/CollisionShape3D
@onready var _collision_detector = $CollisionShape3D
@onready var _sprite = $"Sprite3D"
var type: CC.ConsumableType = CC.ConsumableType.NOT_SET

func _ready() -> void:
	_collision_detector.shape = _collision_detector.shape.duplicate()
	_gravity_collision_shape.shape = _gravity_collision_shape.shape.duplicate()

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
	
	_sprite.scale = Vector3.ONE * size_value
	_sprite.texture = texture
	
	_collision_detector.scale = Vector3.ONE * size_value
	_gravity_collision_shape.scale = Vector3.ONE * size_value
	
	linear_velocity = velocity_direction * velocity_mag
	angular_velocity = spin_direction * spin_speed
	rotation = Vector3(90, 90, 0)
