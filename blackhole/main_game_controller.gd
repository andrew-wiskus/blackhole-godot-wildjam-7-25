class_name GameController extends Node3D

@onready var main_character: MainPlayerRigidBody = $"Main Character"
@onready var currency_label: Label = $"GameHUD/Currency Label"
@export var initial_mass_efficiency = 1.0
@onready var mass_efficiency = initial_mass_efficiency
func _ready() -> void:
	update_currency_hud()

func handle_gravity_upgrade(level_config): 
	main_character.set_gravity_multiplier(level_config.value)

func handle_speed_upgrade(level_config):
	main_character.set_movement_multiplier(level_config.value)
	
func handle_aoe_upgrade(level_config):
	main_character.set_player_size_multiplier(level_config.value)
func handle_mass_efficiency_upgrade(level_config):
	mass_efficiency = initial_mass_efficiency*level_config.value
func handle_passive_mass_upgrade(level_config):
	main_character.set_passive_mass(level_config.value)
func handle_max_zoom_upgrade(level_config):
	main_character.camera.increase_max_zoom(level_config.value)
func update_currency_hud():
	var label_text = "MASS CONSUMED:\n" + str(GameState.currency) + " kg"
	currency_label.text = label_text
	
