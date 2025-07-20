class_name BaseConsumable extends Resource

@export_group("Visuals")
@export var _min_size: float = 1.0
@export var _max_size: float = 1.5
@export var _gravity: float = 0
@export var _sprite_list: Array[Texture2D] = []
@export var _material_list: Array[Material] = []

@export_group("Initial Velocity")
@export var _min_velocity: Vector3
@export var _max_velocity: Vector3
@export var _min_magnitude: float = 0.1
@export var _max_magnitude: float = 0.1

@export_group("Initial Spin")
@export var _min_spin_direction: Vector3
@export var _max_spin_direction: Vector3
@export var _min_spin_magnitude: float = 0.0
@export var _max_spin_magnitude: float = 1.0

var _global_settings: BaseConsumable
var _use_global_gravity = false
var _use_global_size = false
var _use_global_spin = false
var _use_global_velocity = false

func _rand_vec(a: Vector3, b: Vector3) -> Vector3:
	var x = randf_range(a.x, b.x)
	var y = randf_range(a.y, b.y)
	var z = randf_range(a.z, b.z)
	return Vector3(x,y,z)

func velocity_dir(): 
	if _use_global_velocity:
		return _global_settings.velocity_dir()
	return _rand_vec(_min_velocity, _max_velocity)
	
func velocity_magnitude(): 
	if _use_global_velocity:
		return _global_settings.velocity_magnitude()
	return randf_range(_min_magnitude, _max_magnitude)

func spin_dir(): 
	if _use_global_spin:
		return _global_settings.spin_dir()
	return _rand_vec(_min_spin_direction, _max_spin_direction)
	
func spin_magnitude(): 
	if _use_global_spin:
		return _global_settings.spin_magnitude()
	return randf_range(_min_spin_magnitude, _max_spin_magnitude)

func random_size(): 
	if _use_global_size:
		return _use_global_size
	return randf_range(_min_size, _max_size)

func get_gravity():
	if _use_global_gravity:
		return _global_settings.get_gravity()
	return _gravity

func get_sprite():
	if _sprite_list == null or len(_sprite_list) == 0:
		return preload("res://Assets/circle_red.png")
		
	var random_sprite = _sprite_list.pick_random()
	if random_sprite != null:
		return random_sprite
	
	return preload("res://Assets/circle_red.png")

func init(global_settings, use_gravity, use_size, use_spin, use_velocity) -> BaseConsumable:
	_global_settings = global_settings
	_use_global_gravity = !use_gravity
	_use_global_size = !use_size
	_use_global_spin = !use_spin
	_use_global_velocity = !use_velocity
	return self
