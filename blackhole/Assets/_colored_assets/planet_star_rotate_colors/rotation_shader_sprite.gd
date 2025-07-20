class_name RotationShaderSprite extends Node3D

func set_material(material: Material):
	$"animated_planet".material_override = material
	# do some randomization w/ shader props here.. or feed them in from params
