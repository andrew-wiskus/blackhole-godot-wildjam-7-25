extends Node3D
@export var planet_count = 6
@export var planet_spacing = 250
@export var orbiting_speed = 1000
var _object_spawner: ObjectSpawnUtil
func _ready() -> void:
	_object_spawner = get_tree().get_first_node_in_group("object_spawn_util")
	
	for n in range(planet_count):
		var position = Vector3.FORWARD*(n+1)*planet_spacing
		_object_spawner.spawn_consumable_object(self, CC.ConsumableType.STAR_SM, position)
