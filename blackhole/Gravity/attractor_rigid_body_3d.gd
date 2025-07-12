extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	if body is GPUParticles3D:
		print("entered GPUParticles")
	pass # Replace with function body.
