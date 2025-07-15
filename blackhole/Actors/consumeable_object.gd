extends RigidBody3D
@export_group("size")
@export var general_size: float = 1.0
@export var gravity_area_strength = 9.8

func init(): # set sprite/size/gravity/etc
	pass

func _ready() -> void:
	$Area3D.gravity = gravity_area_strength
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
func increase_gravity(step):
	$"Rigid_Body_Gravity_Area".gravity += step
func increase_size(step):
	general_size += step	
	# update gravity/etc
