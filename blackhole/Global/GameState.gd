extends Node

var currency: int = 100:
	get:
		return currency
	set(value):
		currency = value
		game_controller.update_currency_hud()
		
var current_upgrade_levels: Dictionary[ShopConfig.UpgradeID, int] = {}
var game_paused: bool = false
var game_controller: GameController

func _ready():
	_load_game_state()
	game_controller = get_tree().get_first_node_in_group("game_controller")
	pass

func _load_game_state():
	for item in ShopConfig.UPGRADE_CONFIG:
		current_upgrade_levels.set(item.id, 0) # TODO: load in currently bought upgrades/current/etc
	

func _save_game_state():
	# TODO: save state.. godot has built in local storage to use for now
	pass

func _handle_game_paused(paused: bool):
	game_paused = paused
	# do other things probably
	# you can use 
	# get_tree().paused = true
func pause_game(): _handle_game_paused(true)
func resume_game(): _handle_game_paused(false)
func toggle_pause(): _handle_game_paused(!game_paused)


func try_purchase(cost: int):
	if currency < cost:
		return false
	
	currency = currency - cost
	return true

func on_consume_increase_currency(amount: float):
	currency += amount*game_controller.mass_efficiency
	
