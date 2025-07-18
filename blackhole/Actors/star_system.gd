extends Node3D
@export var planet_count = 6
@export var planet_spacing = 250
@export var star_size = 50
@export var star_gravity_area = 1000 #meters

func _ready() -> void:
	var consumable = preload("res://Actors/consumeable_object.tscn")
	for n in range(planet_count):
		var planet = consumable.instantiate()
		planet.position = Vector3.FORWARD*(n+1)*planet_spacing
		planet.general_size = 20 + randi_range(-5,+ 5)
		add_child(planet)
