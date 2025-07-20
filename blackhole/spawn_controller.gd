class_name SpawnController extends Node3D

var spawn_points: Dictionary[String, Vector3] = {} # updated in ObjectSpawnUtil
var node_lookup: Dictionary[String, ConsumeableObject] = {} # updated in ObjectSpawnUtil
var _spawn_util: ObjectSpawnUtil

func _ready() -> void:
	_spawn_util = get_tree().get_first_node_in_group("object_spawn_util")

func save_spawn_reference(node: ConsumeableObject, spawn_point: Vector3):
	spawn_points.set(node.uuid, spawn_point)
	node_lookup.set(node.uuid, node)

func handle_consumable_queue_free(node: ConsumeableObject):
	if node.type != CC.ConsumableType.ASTEROID_SM:
		print("Respawning...")
	if !node_lookup.has(node.uuid):
		return
	
	var ref = { type = node.type, spawn_point = spawn_points.get(node.uuid) }.duplicate() # duplicate to save ref since we're queue_free next line
	
	node_lookup.erase(node.uuid)
	spawn_points.erase(node.uuid)
	node.queue_free()
	
	if ref.type == CC.ConsumableType.ASTEROID_SM or ref.type == CC.ConsumableType.ASTEROID_LG:
		if GameState.stop_spawning_smalls == true:
			var random_chance = randf() 
			if random_chance <= 0.005:
				await get_tree().create_timer(GameState.config_lookup.get(ref.type).base_respawn_timer).timeout
				_spawn_util.spawn_consumable_object(self, CC.ConsumableType.PLANET_SM, ref.spawn_point)
			if random_chance <= 0.05:
				await get_tree().create_timer(GameState.config_lookup.get(ref.type).base_respawn_timer).timeout
				_spawn_util.spawn_consumable_object(self, ref.type, ref.spawn_point)
