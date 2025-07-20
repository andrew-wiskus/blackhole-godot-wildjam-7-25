class_name ConsumeableObject extends RigidBody3D

@export var use_custom_sprite: bool = false
@export var particles: GPUParticles3D

@onready var _gravity_area_3d: Area3D = $GravityArea3D
@onready var _gravity_collision_shape: CollisionShape3D = $GravityArea3D/CollisionShape3D
@onready var _collision_detector: CollisionShape3D = $CollisionShape3D
@onready var _sprite_container: Node3D = $"Sprite Container"
@onready var _image__sprite: Sprite3D = $"Sprite Container/Image - Sprite"
@onready var _image__rotation_material: RotationShaderSprite = $"Sprite Container/Image - Rotation Material"
@onready var screen_notifier := $VisibleOnScreenNotifier3D

var type: CC.ConsumableType = CC.ConsumableType.NOT_SET
var general_size 
var _is_on_screen = false
var object_display_uses_sprite3D = false
var uuid: String
var config: BaseConsumable
var _spawn_controller: SpawnController

func _ready() -> void:
	_on_screen_exited()
	_collision_detector.shape = _collision_detector.shape.duplicate()
	_gravity_collision_shape.shape = _gravity_collision_shape.shape.duplicate()
	_spawn_controller = get_tree().get_first_node_in_group("spawn_controller")
	screen_notifier.screen_entered.connect(_on_screen_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)
	uuid = "consumable_obj__" + str(randi_range(0, 9999999))

func _on_screen_entered():
	_is_on_screen = true
	set_physics_process(true)
	visible = true
	# Resume any particle effects, animations, etc.

func _on_screen_exited():
	_is_on_screen = false
	set_physics_process(false)

func init(
		type_id: CC.ConsumableType, 
		grav_str: float, 
		size_value: float, 
		velocity_direction: Vector3, 
		velocity_mag: float, 
		spin_direction: Vector3, 
		spin_speed: float,
		_config: BaseConsumable
	):
	type = type_id
	config = _config
	_gravity_area_3d.gravity = grav_str
	_gravity_area_3d.monitoring = false # updated in set_size
	set_size(size_value)

	if use_custom_sprite != true: 
		set_object_display_for_type()
	else: # ^ think we can remove this if/else and just `set_object_display_for_type(config)`
		_image__sprite.show()
		_image__rotation_material.hide()
		object_display_uses_sprite3D = true
		
	linear_velocity = velocity_direction * velocity_mag
	update_gravity_scale()


func set_size(target_size): # set to 20.0
	general_size = target_size
	_collision_detector.scale = Vector3.ONE * general_size

	_gravity_collision_shape.scale = Vector3.ONE * general_size

	set_object_display_scale(general_size)
	if particles:
		particles.multiplier_particle_size(target_size)
	
	if has_node("Player_Vicinity_Check"):
		$Player_Vicinity_Check.get_child(0).scale = Vector3.ONE * general_size
		
	if target_size <= 50: 
		monitor_gravity(false)
	else:
		monitor_gravity(true)

func set_size_multiplier(multi): # increase by 2.0x
	var new_size = general_size * multi
	set_size(new_size)

func on_death():
	_spawn_controller.handle_consumable_queue_free(self)

func set_object_display_for_type():
	var sprites = config._sprite_list
	var materials = config._material_list
	if len(materials) > 0:
		var material = materials.pick_random()
		_image__rotation_material.set_material(material)
		_image__sprite.hide()
		return
	
	_image__rotation_material.hide()
	_image__sprite.texture = config.get_sprite()

func set_object_display_scale(size_value):
	var updated_scale = Vector3.ONE * general_size
	_sprite_container.scale = updated_scale

func hide_object_display():
	_image__sprite.hide()
	_image__rotation_material.hide()
	
func monitor_gravity(should_monitor):
	_gravity_area_3d.monitoring = false # should_monitor
	
# event listener fired from @
func handle_collision_with_player(delta: float):
	const MIN_SIZE_FOR_QUEUE_FREE = 0.2 
	
	if GameState.player_can_instant_consume(type):
		GameState.handle_consume_object(type, general_size)
		_spawn_controller.handle_consumable_queue_free(self)
	else:
		var consume_rate_per_sec = GameState.get_consume_rate_per_sec(type)
		var consumed_this_tick = consume_rate_per_sec * delta
		var new_size = general_size - consumed_this_tick
		
		if new_size <= MIN_SIZE_FOR_QUEUE_FREE:
			_spawn_controller.handle_consumable_queue_free(self)
			GameState.handle_consume_object(type, max(0, new_size))
		else: 
			set_size(new_size)
			GameState.handle_consume_object(type, consumed_this_tick)

func update_gravity_scale():
	gravity_scale = GameState.gravity_scale_for_type(type)
