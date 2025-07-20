class_name AsteroidSystem
extends Node3D

# Configuration for asteroid spawning
@export_category("Asteroid Configuration")
@export var total_asteroids: int = 100
@export var spawn_on_ready: bool = true
@export var continuous_spawning: bool = false
@export var spawn_rate: float = 1.0  # Asteroids per second when continuous
@export var consumable_types: Array[CC.ConsumableType]
# Boundary configuration
@export_category("Boundary Configuration")
enum BoundaryType { SPHERE, BOX }
@export var boundary_type: BoundaryType = BoundaryType.SPHERE
@export var boundary_radius: float = 1000.0  # For sphere
@export var min_distance_from_center: float = 1
@export var spawn_distance_threshold: float = 500.0  # Only spawn within this distance from player



# Internal variables
var _noise: FastNoiseLite
var _spawn_timer: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _player_node: Node3D = null
var _object_spawner: ObjectSpawnUtil

func _ready():
	
	
	_noise = FastNoiseLite.new()
	_noise.seed = _rng.randi()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	_noise.get_noise_2d(0, 0)
	
	_player_node = get_tree().get_first_node_in_group("player_node")
	_object_spawner = get_tree().get_first_node_in_group("object_spawn_util")
	
	if visible:
		if spawn_on_ready:
			spawn_asteroid_field(total_asteroids)

func _process(delta):
	if continuous_spawning:
		_spawn_timer += delta
		var to_spawn = floor(_spawn_timer * spawn_rate)
		if to_spawn >= 1:
			_spawn_timer -= to_spawn / spawn_rate
			for i in range(to_spawn):
				spawn_single_object()
	
func spawn_asteroid_field(count: int):
	for i in range(count):
		spawn_single_object()

func spawn_single_object():
	var id
	id = randi() % len(consumable_types)
	_object_spawner.spawn_consumable_object(self, consumable_types[id], _get_spawn_position())
	

func _get_spawn_position() -> Vector3:
	var position: Vector3

	# Use noise to create more natural clustering
	var angle = _rng.randf() * TAU  # Random angle in radians
	var distance = _rng.randf_range(min_distance_from_center, boundary_radius)
	
	# Convert polar coordinates to cartesian (2D)
	var x = cos(angle) * distance
	var z = sin(angle) * distance
	
	return Vector3(x, 0, z)


func clear_asteroids():
	for child in get_children():
		if child.is_in_group("asteroid") or child.name.begins_with("Asteroid"):
			child.queue_free()

func set_boundary_sphere(radius: float):
	boundary_type = BoundaryType.SPHERE
	boundary_radius = radius
