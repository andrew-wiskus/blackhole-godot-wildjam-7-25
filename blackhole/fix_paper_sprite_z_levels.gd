extends Node3D

func _ready():
	var y_step = 0.1
	for child: Node3D in get_children():
		var updated_y = Vector3.ZERO
		updated_y.y -= y_step
		child.translate(updated_y)
		y_step += 0.1
