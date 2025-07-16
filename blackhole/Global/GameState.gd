extends Node

var currency: int = 10
var upgrades: Dictionary[ShopConfig.UpgradeID, int] = {}
var game_paused: bool = false

func _ready():
	_load_game_state()
	pass

func _load_game_state():
	for item in ShopConfig.UPGRADE_CONFIG:
		upgrades.set(item.id, 0) # TODO: load in currently bought upgrades/current/etc
	

func _save_game_state():
	# TODO: save state.. godot has built in local storage to use for now
	pass

func _handle_game_paused(paused: bool):
	game_paused = paused
	# do other things probably

func pause_game(): _handle_game_paused(true)
func resume_game(): _handle_game_paused(false)
func toggle_pause(): _handle_game_paused(!game_paused)
