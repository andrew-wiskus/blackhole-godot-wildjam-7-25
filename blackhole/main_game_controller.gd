class_name GameController extends Node3D

@onready var main_character: MainPlayerRigidBody = $"Main Character"
@onready var currency_label: Label = $"GameHUD/Currency Label"

func _ready() -> void:
	update_currency_hud()

func handle_gravity_upgrade(level_config): 
	main_character.set_gravity_multiplier(level_config.value)

func handle_speed_upgrade(level_config):
	main_character.set_movement_multiplier(level_config.value)
	
func handle_aoe_upgrade(level_config):
	main_character.set_player_size_multiplier(level_config.value)

func update_currency_hud():
	var label_text = "MASS CONSUMED:\n" + str(GameState.currency) + " kg"
	currency_label.text = label_text
	
