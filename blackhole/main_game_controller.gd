class_name GameController extends Node3D

@onready var main_character = $"Main Character"

func _ready() -> void:
	print(main_character)

func handle_gravity_upgrade(level_config): print("TODO: Upgrade gravity strength")
func handle_speed_upgrade(level_config): print("TODO: Upgrade speed")
func handle_aoe_upgrade(level_config): print("TODO: Upgrade area of effect")
