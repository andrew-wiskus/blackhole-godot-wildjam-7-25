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
	_init_config_lookup_map()
	_spawn_controller = get_tree().get_first_node_in_group("spawn_controller")
	
func _init_config_lookup_map():
	GameState.config_lookup.set(CC.ConsumableType.ASTEROID_SM, global_settings if asteroid_sm_overrides == null else asteroid_sm_overrides.init(global_settings, asteroid_sm_override_gravity, asteroid_sm_override_size, asteroid_sm_override_spin, asteroid_sm_override_velocity))
	GameState.config_lookup.set(CC.ConsumableType.ASTEROID_LG, global_settings if asteroid_lg_overrides == null else asteroid_lg_overrides.init(global_settings, asteroid_lg_override_gravity, asteroid_lg_override_size, asteroid_lg_override_spin, asteroid_lg_override_velocity))
	GameState.config_lookup.set(CC.ConsumableType.PLANET_SM, global_settings if planet_sm_overrides == null else planet_sm_overrides.init(global_settings, planet_sm_override_gravity, planet_sm_override_size, planet_sm_override_spin, planet_sm_override_velocity))
	GameState.config_lookup.set(CC.ConsumableType.PLANET_LG, global_settings if planet_lg_overrides == null else planet_lg_overrides.init(global_settings, planet_lg_override_gravity, planet_lg_override_size, planet_lg_override_spin, planet_lg_override_velocity))
	GameState.config_lookup.set(CC.ConsumableType.STAR_SM, global_settings if star_sm_overrides == null else star_sm_overrides.init(global_settings, star_sm_override_gravity, star_sm_override_size, star_sm_override_spin, star_sm_override_velocity))
	GameState.config_lookup.set(CC.ConsumableType.STAR_LG, global_settings if star_lg_overrides == null else star_lg_overrides.init(global_settings, star_lg_override_gravity, star_lg_override_size, star_lg_override_spin, star_lg_override_velocity))

func spawn_consumable_object(parent_node: Node3D, type: CC.ConsumableType, spawn_position: Vector3) -> ConsumeableObject:
	var scene = preload("res://Actors/consumeable_object.tscn")
	var config = GameState.config_lookup.get(type)
	if config == null:
		print("??? CONFIG SHOULD NOT BE NULL ??", type)
	
	var instance := scene.instantiate() as ConsumeableObject
	parent_node.add_child(instance)
	
	instance.global_position = spawn_position
	
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

	return instance
