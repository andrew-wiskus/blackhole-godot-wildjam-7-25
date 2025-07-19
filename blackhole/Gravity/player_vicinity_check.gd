extends Area3D
var main_body
#decreases size of the parent if hits this collision
func _physics_process(delta: float) -> void:
	if main_body:
		get_parent().set_size_multiplier(0.999)
		GameState.on_consume_increase_currency(get_parent().general_size*.001)
		if get_parent().general_size < main_body.general_size:
			GameState.on_consume_increase_currency(get_parent().general_size)
			get_parent().queue_free()
			

func _on_body_entered(body: Node3D) -> void:
	if body is MainPlayerRigidBody:
		main_body = body # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body is MainPlayerRigidBody:
		main_body = null
	pass # Replace with function body.
