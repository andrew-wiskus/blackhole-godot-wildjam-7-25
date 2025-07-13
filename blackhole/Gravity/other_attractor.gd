extends RigidBody3D
@export_group("size")
@export var general_size: float = 1.0
@export var initial_gravity_scale = gravity_scale
@export var initial_gravity_area_strength = 9.8
@export var initial_mass = mass
@onready var initial_inner_scale = $CollisionShape3D.scale 
@onready var initial_gravity_radius_scale = $Area3D/CollisionShape3D.scale
func _ready() -> void:
	linear_velocity.x = 1
	$Sprite3D.scale = Vector3.ONE*general_size
	#make collision shapes unique
	$CollisionShape3D.shape = $CollisionShape3D.shape.duplicate()
	$Area3D/CollisionShape3D.shape = $Area3D/CollisionShape3D.shape.duplicate()
	$CollisionShape3D.scale = Vector3.ONE*general_size
	$Area3D/CollisionShape3D.scale = Vector3.ONE*general_size

func update_size(size:Vector3):
	$Sprite3D.scale = size
	$CollisionShape3D.scale = size
	$Area3D/CollisionShape3D.scale =  size
func increase_size(step:Vector3):
	$Sprite3D.scale += step
	$CollisionShape3D.scale += step
	$Area3D/CollisionShape3D.scale +=  step	

	
	
