extends RigidBody3D
@export_group("size")
@export var general_size: float = 1.0
@export var initial_gravity_scale = gravity_scale
@export var initial_gravity_area_strength = 9.8
@export var initial_mass = mass
@onready var initial_inner_scale = $CollisionShape3D.scale 
@onready var initial_gravity_radius_scale = $Area3D/CollisionShape3D.scale

func init(): # set sprite/size/gravity/etc
	pass

func _ready() -> void:
	linear_velocity.x = 1
	$Sprite3D.scale = Vector3.ONE*general_size
	#make collision shapes unique
	$CollisionShape3D.shape = $CollisionShape3D.shape.duplicate()
	$Area3D/CollisionShape3D.shape = $Area3D/CollisionShape3D.shape.duplicate()
	$CollisionShape3D.scale = Vector3.ONE*general_size
	$Area3D/CollisionShape3D.scale = Vector3.ONE*general_size


func update_size(multiplier: float):
	var scale_multi = Vector3.ONE * multiplier
	general_size = multiplier
	$Sprite3D.scale = scale_multi
	$CollisionShape3D.scale = scale_multi
	$Area3D/CollisionShape3D.scale =  scale_multi
	
	# update gravity/etc
