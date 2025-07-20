extends Node3D

func _ready() -> void:
	print(ShopConfig.load_upgrade_config_from_csv())
