extends Node3D

@export var sm_asteroid_amount: int = 0
@export var lg_asteroid_amount: int = 0
@export var sm_planet_amount: int = 0
@export var lg_planet_amount: int = 0
@export var sm_star_amount: int = 0
@export var lg_star_amount: int = 0

@onready var spawn_boundary: CSGPolygon3D = $"Spawn Area Boundary"

var _spawn_util: ObjectSpawnUtil
var _spawn_controller: Node3D
var _polygon_points: PackedVector2Array

func _ready() -> void:
	var drawn_shape_points = spawn_boundary.polygon.duplicate()
	for point in drawn_shape_points:
		_polygon_points.append(Vector2(point.x + global_position.x, point.y + global_position.z))
	_spawn_util = get_tree().get_first_node_in_group("object_spawn_util")
	_spawn_controller = get_tree().get_first_node_in_group("spawn_controller")
	
	await _spawn_controller.ready
	
	spawn_object_field(CC.ConsumableType.ASTEROID_SM, sm_asteroid_amount)
	spawn_object_field(CC.ConsumableType.ASTEROID_LG, sm_asteroid_amount)
	spawn_object_field(CC.ConsumableType.PLANET_SM, sm_planet_amount)
	spawn_object_field(CC.ConsumableType.PLANET_LG, lg_planet_amount)
	spawn_object_field(CC.ConsumableType.STAR_SM, sm_star_amount)
	spawn_object_field(CC.ConsumableType.STAR_LG, lg_star_amount)
	spawn_boundary.queue_free()


func spawn_object_field(type, amount):
	
	var spawn_points = get_gaussian_distribution(_polygon_points, amount)
	
	for point in spawn_points:
		var spawn_point = Vector3(point.x, 0, point.y)
		var object_node = _spawn_util.spawn_consumable_object(_spawn_controller, type, spawn_point)


func get_gaussian_distribution(polygon: Array[Vector2], num_points: int) -> Array[Vector2]:
	# Compute bounding box
	var xs := polygon.map(func(p): return p.x)
	var ys := polygon.map(func(p): return p.y)
	var min_x = xs.min()
	var max_x = xs.max()
	var min_y = ys.min()
	var max_y = ys.max()
	
	var mean := Vector2((min_x + max_x) * 0.5, (min_y + max_y) * 0.5)
	var deviation := Vector2((max_x - min_x) * 0.25, (max_y - min_y) * 0.25)
	
	var result: Array[Vector2] = []  # Array[Vector2]
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	while result.size() < num_points:
		var x := rng.randfn(mean.x, deviation.x)
		var y := rng.randfn(mean.y, deviation.y)
		if point_is_in_polygon(x, y, polygon):
			result.append(Vector2(x, y))
	
	return result
	
### BELOW THIS POINT IS GPT-MATH-MAGIC TO CALCULATE POINTS INSIDE AN ARBITRARY POLYGON ###
################## EDIT ANY VALUES AT RISK OF IMPOSSIBLE TO FIX ERRORS ##################

func point_is_in_polygon(x: float, y: float, polygon: Array[Vector2]) -> bool:
	var inside: bool = false
	var n: int = polygon.size()
	for i in range(n):
		var j: int = (i + 1) % n
		var xi: float = polygon[i].x
		var yi: float = polygon[i].y
		var xj: float = polygon[j].x
		var yj: float = polygon[j].y
		
		if (yi > y) != (yj > y):
			var x_intersect: float = xi + (y - yi) * (xj - xi) / (yj - yi)
			if x_intersect == x:
				return true
			if x_intersect > x:
				inside = not inside
	return inside

func get_random_point_in_polygon(polygon: Array[Vector2]) -> Vector2:
	var xs: Array = []
	var ys: Array = []
	for p in polygon:
		xs.append(p.x)
		ys.append(p.y)
	var min_x: float = xs.min()
	var max_x: float = xs.max()
	var min_y: float = ys.min()
	var max_y: float = ys.max()

	# Set up RNG once
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var dont_crash_error_check = 0
	while true:
		var rx: float = rng.randf_range(min_x, max_x)
		var ry: float = rng.randf_range(min_y, max_y)
		if point_is_in_polygon(rx, ry, polygon):
			return Vector2(rx, ry)
		dont_crash_error_check += 1
		if dont_crash_error_check > 50:
			printerr("COULDNT FIND RANDOM POSITION -> RETURNING 0,0")
			return Vector2(0,0)
	
	return Vector2(0,0)


# Shoelace formula for polygon area
func _get_polygon_area(polygon: Array[Vector2]) -> float:
	var area: float = 0.0
	var n: int = polygon.size()
	for i in range(n):
		var j: int = (i + 1) % n
		area += polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y
	return abs(area) * 0.5

# Evenly (approx.) spaced points in a polygon, fallback to random sampling
func get_uniform_points_in_polygon(polygon: Array[Vector2], num_points: int) -> Array[Vector2]:
	# Compute bounding box
	var xs: Array[float] = []
	var ys: Array[float] = []
	for p in polygon:
		xs.append(p.x)
		ys.append(p.y)
	var min_x: float = xs.min()   # Array.min() returns the minimum element  [oai_citation:0‡Godot Engine documentation](https://docs.godotengine.org/en/4.3/classes/class_array.html?utm_source=chatgpt.com)
	var max_x: float = xs.max()   # Array.max() returns the maximum element  [oai_citation:1‡Godot Engine documentation](https://docs.godotengine.org/en/4.3/classes/class_array.html?utm_source=chatgpt.com)
	var min_y: float = ys.min()
	var max_y: float = ys.max()

	# Determine grid spacing from area
	var area: float = _get_polygon_area(polygon)
	var spacing: float = sqrt(area / num_points)   # sqrt() is a built-in GDScript function  [oai_citation:2‡Godot Engine documentation](https://docs.godotengine.org/en/3.0/classes/class_%40gdscript.html?utm_source=chatgpt.com)

	# Number of grid cells in each dimension
	var nx: int = max(1, int((max_x - min_x) / spacing) + 1)
	var ny: int = max(1, int((max_y - min_y) / spacing) + 1)

	var dx: float = ((max_x - min_x) / (nx - 1)) if nx > 1 else 0.0
	var dy: float = ((max_y - min_y) / (ny - 1)) if ny > 1  else 0.0

	# Collect grid candidates that lie inside
	var candidates: Array[Vector2] = []
	for i in range(nx):
		for j in range(ny):
			var px: float = min_x + i * dx
			var py: float = min_y + j * dy
			if point_is_in_polygon(px, py, polygon):
				candidates.append(Vector2(px, py))

	# If enough, sample evenly along the candidate list
	if candidates.size() >= num_points:
		var step: float = float(candidates.size()) / num_points
		var even_sample_result: Array[Vector2] = []
		for k in range(num_points):
			even_sample_result.append(candidates[int(k * step)])
		return even_sample_result

	# Otherwise, fall back to random sampling to fill up
	var result: Array[Vector2] = candidates.duplicate()
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	while result.size() < num_points:
		var rx: float = rng.randf_range(min_x, max_x)   # randf_range() on RNG  [oai_citation:3‡Godot Engine documentation](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html?utm_source=chatgpt.com)
		var ry: float = rng.randf_range(min_y, max_y)
		if point_is_in_polygon(rx, ry, polygon):
			result.append(Vector2(rx, ry))
	return result
