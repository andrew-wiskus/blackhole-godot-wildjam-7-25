extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node3D) -> void:
	# make the body orbit you
	pass # Replace with function body.
