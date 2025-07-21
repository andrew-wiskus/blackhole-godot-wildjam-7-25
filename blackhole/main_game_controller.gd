class_name GameController extends Node3D

@onready var main_character: MainPlayerRigidBody = $"Main Character"
@onready var currency_label: Label = $"GameHUD/Currency Label"
@export var initial_mass_efficiency = 2.0
@onready var mass_efficiency = initial_mass_efficiency
func _ready() -> void:
	update_currency_hud()
	GameState.mass_efficiency = initial_mass_efficiency

func handle_gravity_upgrade(level_config): 
	main_character.set_gravity_multiplier(level_config.value)

func handle_speed_upgrade(level_config):
	main_character.set_movement_multiplier(level_config.value)
	
func handle_aoe_upgrade(level_config):
	main_character.set_player_size_multiplier(level_config.value)
	if level_config.value > 5.0:
		GameState.stop_spawning_smalls = true
func handle_mass_efficiency_upgrade(level_config):
	mass_efficiency = initial_mass_efficiency*level_config.value
	GameState.mass_efficiency = mass_efficiency
func handle_passive_mass_upgrade(level_config):
	main_character.set_passive_mass(level_config.value)
func handle_max_zoom_upgrade(level_config):
	main_character.camera.increase_max_zoom(level_config.value)
func update_currency_hud():
	var mass_str = ""
	if GameState.currency > 10000:
		mass_str = round(GameState.currency)
	else:
		mass_str = str(roundf(GameState.currency * 100.0) / 100.0)
	
	var label_text = "MASS CONSUMED: (Press Tab For Upgrades)\n" + mass_str + " kg"
	currency_label.text = label_text
	
