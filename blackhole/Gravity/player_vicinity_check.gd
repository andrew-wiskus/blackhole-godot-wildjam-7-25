extends Area3D

var player_node_is_colliding: bool = false

func _physics_process(delta: float) -> void:
	if player_node_is_colliding:
		get_parent().handle_collision_with_player(delta)

func _on_body_entered(body: Node3D) -> void:
	if body is MainPlayerRigidBody:
		player_node_is_colliding = true


func _on_body_exited(body: Node3D) -> void:
	if body is MainPlayerRigidBody:
		player_node_is_colliding = false
