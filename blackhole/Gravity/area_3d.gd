extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node3D) -> void:
	print("entered")
	pass # Replace with function body.
