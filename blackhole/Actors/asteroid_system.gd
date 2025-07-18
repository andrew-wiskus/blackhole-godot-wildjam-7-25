class_name AsteroidSystem
extends Node3D

# Configuration for asteroid spawning
@export_category("Asteroid Configuration")
@export var asteroid_scenes: Array[PackedScene] = []
@export var total_asteroids: int = 100
@export var spawn_on_ready: bool = true
@export var continuous_spawning: bool = false
@export var spawn_rate: float = 1.0  # Asteroids per second when continuous

# Boundary configuration
@export_category("Boundary Configuration")
enum BoundaryType { SPHERE, BOX }
@export var boundary_type: BoundaryType = BoundaryType.SPHERE
@export var boundary_radius: float = 1000.0  # For sphere
@export var boundary_size: Vector3 = Vector3(1000, 1000, 1000)  # For box
@export var min_distance_from_center: float = 100.0
@export var exclude_cone_angle: float = 30.0  # Degrees - to avoid spawning in front of player

# Asteroid properties
@export_category("Asteroid Properties")
@export var min_scale: float = 0.5
@export var max_scale: float = 3.0
@export var randomize_rotation: bool = true
@export var add_random_velocity: bool = true
@export var min_velocity: float = 0.0
@export var max_velocity: float = 5.0
@export var use_noise_for_distribution: bool = true
@export var noise_scale: float = 0.1
@export var noise_seed: int = 0

# Internal variables
var _noise: FastNoiseLite
var _spawn_timer: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _player_node: Node3D = null
var _object_spawner: ObjectSpawnUtil

func _ready():
	if asteroid_scenes.size() == 0:
		push_warning("No asteroid scenes assigned to AsteroidSystem!")
		return
	
	_rng.seed = noise_seed if noise_seed > 0 else Time.get_unix_time_from_system()
	
	_noise = FastNoiseLite.new()
	_noise.seed = _rng.randi()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	
	_player_node = get_tree().get_first_node_in_group("player_node")
	_object_spawner = get_tree().get_first_node_in_group("object_spawn_util")
	
	if spawn_on_ready:
		spawn_asteroid_field(total_asteroids)

func _process(delta):
	if continuous_spawning:
		_spawn_timer += delta
		var to_spawn = floor(_spawn_timer * spawn_rate)
		if to_spawn >= 1:
			_spawn_timer -= to_spawn / spawn_rate
			for i in range(to_spawn):
				spawn_single_object(CC.ConsumableType.ASTEROID_SM)
	
func spawn_asteroid_field(count: int):
	for i in range(count):
		spawn_single_object(CC.ConsumableType.ASTEROID_SM)

func spawn_single_object(type: CC.ConsumableType):
	var id
	if randf() > 0.5:
		id = CC.ConsumableType.ASTEROID_LG
	else:
		id = CC.ConsumableType.ASTEROID_SM
	_object_spawner.spawn_consumable_object(self, id, _get_spawn_position())
	

func _get_spawn_position() -> Vector3:
	var position: Vector3
	
	if use_noise_for_distribution:
		# Use noise to create more natural clustering
		var attempt = 0
		var max_attempts = 10
		
		while attempt < max_attempts:
			position = _get_basic_random_position()
			
			# Use noise to determine if this position is valid
			var noise_value = _noise.get_noise_3d(
				position.x * noise_scale,
				position.y * noise_scale,
				position.z * noise_scale
			)
			
			# Normalize noise from [-1,1] to [0,1]
			noise_value = (noise_value + 1.0) / 2.0
			
			# Higher noise values mean higher chance of spawning
			if _rng.randf() < noise_value:
				break
				
			attempt += 1
			
		if attempt >= max_attempts:
			position = _get_basic_random_position()
	else:
		position = _get_basic_random_position()
	
	return position

func _get_basic_random_position() -> Vector3:
	var position: Vector3
	
	if boundary_type == BoundaryType.SPHERE:
		# Get random point in a spherical shell
		var phi = _rng.randf_range(0, TAU)
		var costheta = _rng.randf_range(-1, 1)
		var theta = acos(costheta)
		
		var r = _rng.randf_range(min_distance_from_center, boundary_radius)
		
		position = Vector3(
			r * sin(theta) * cos(phi),
			r * sin(theta) * sin(phi),
			r * cos(theta)
		)
	else:  # BoundaryType.BOX
		position = Vector3(
			_rng.randf_range(-boundary_size.x/2, boundary_size.x/2),
			_rng.randf_range(-boundary_size.y/2, boundary_size.y/2),
			_rng.randf_range(-boundary_size.z/2, boundary_size.z/2)
		)
		
		# Ensure minimum distance from center
		if position.length() < min_distance_from_center:
			position = position.normalized() * min_distance_from_center
	
	return position

func clear_asteroids():
	for child in get_children():
		if child.is_in_group("asteroid") or child.name.begins_with("Asteroid"):
			child.queue_free()

func set_boundary_sphere(radius: float):
	boundary_type = BoundaryType.SPHERE
	boundary_radius = radius

func set_boundary_box(size: Vector3):
	boundary_type = BoundaryType.BOX
	boundary_size = size
