@tool
class_name ObjectSpawnUtil extends Node
@export_group("Global Settings: (Can override)")
@export var global_settings: BaseConsumable

@export_group("Overrides")
@export_subgroup("Asteroid Small")
@export var asteroid_sm_override_gravity: bool = false
@export var asteroid_sm_override_size: bool = false
@export var asteroid_sm_override_spin: bool = false
@export var asteroid_sm_override_velocity: bool = false

@export var asteroid_sm_overrides: BaseConsumable

@export_subgroup("Asteroid Large")
@export var asteroid_lg_override_gravity: bool = false
@export var asteroid_lg_override_size: bool = false
@export var asteroid_lg_override_spin: bool = false
@export var asteroid_lg_override_velocity: bool = false

@export var asteroid_lg_overrides: BaseConsumable

@export_subgroup("Planet Small")
@export var planet_sm_override_gravity: bool = false
@export var planet_sm_override_size: bool = false
@export var planet_sm_override_spin: bool = false
@export var planet_sm_override_velocity: bool = false

@export var planet_sm_overrides: BaseConsumable

@export_subgroup("Planet Large")
@export var planet_lg_override_gravity: bool = false
@export var planet_lg_override_size: bool = false
@export var planet_lg_override_spin: bool = false
@export var planet_lg_override_velocity: bool = false

@export var planet_lg_overrides: BaseConsumable


@export_subgroup("Star Small")
@export var star_sm_override_gravity: bool = false
@export var star_sm_override_size: bool = false
@export var star_sm_override_spin: bool = false
@export var star_sm_override_velocity: bool = false

@export var star_sm_overrides: BaseConsumable

@export_subgroup("Star Large")
@export var star_lg_override_gravity: bool = false
@export var star_lg_override_size: bool = false
@export var star_lg_override_spin: bool = false
@export var star_lg_override_velocity: bool = false

@export var star_lg_overrides: BaseConsumable

var _spawn_controller: SpawnController

func _ready() -> void:
	_spawn_controller = get_tree().get_first_node_in_group("spawn_controller")

func spawn_consumable_object(parent_node: Node3D, type: CC.ConsumableType, spawn_position: Vector3) -> ConsumeableObject:
	var config: BaseConsumable
	var scene = preload("res://Actors/consumeable_object.tscn")
	if type == CC.ConsumableType.ASTEROID_SM: 
		config = global_settings if asteroid_sm_overrides == null else asteroid_sm_overrides.init(global_settings, asteroid_sm_override_gravity, asteroid_sm_override_size, asteroid_sm_override_spin, asteroid_sm_override_velocity)
	
	if type == CC.ConsumableType.ASTEROID_LG: 
		config = global_settings if asteroid_lg_overrides == null else asteroid_lg_overrides.init(global_settings, asteroid_lg_override_gravity, asteroid_lg_override_size, asteroid_lg_override_spin, asteroid_lg_override_velocity)
	
	if type == CC.ConsumableType.PLANET_SM: 
		config = global_settings if planet_sm_overrides == null else planet_sm_overrides.init(global_settings, planet_sm_override_gravity, planet_sm_override_size, planet_sm_override_spin, planet_sm_override_velocity)
	
	if type == CC.ConsumableType.PLANET_LG: 
		config = global_settings if planet_lg_overrides == null else planet_lg_overrides.init(global_settings, planet_lg_override_gravity, planet_lg_override_size, planet_lg_override_spin, planet_lg_override_velocity)
	
	if type == CC.ConsumableType.STAR_SM:   
		config = global_settings if star_sm_overrides == null else star_sm_overrides.init(global_settings, star_sm_override_gravity, star_sm_override_size, star_sm_override_spin, star_sm_override_velocity)
	
	if type == CC.ConsumableType.STAR_LG:
		config = global_settings if star_lg_overrides == null else star_lg_overrides.init(global_settings, star_lg_override_gravity, star_lg_override_size, star_lg_override_spin, star_lg_override_velocity)
	
	if config == null:
		print("???", type)
	
	
	var instance := scene.instantiate() as ConsumeableObject
	parent_node.add_child(instance)
	
	instance.position = spawn_position
	
	instance.init(
		type, 
		config.get_gravity(), 
		config.random_size(), 
		config.velocity_dir(), 
		config.velocity_magnitude(), 
		config.spin_dir(), 
		config.spin_magnitude(),
		config
	)
	
	_spawn_controller.save_spawn_reference(instance, spawn_position)
	
	print("SPAWNED NODE!")

	return instance
