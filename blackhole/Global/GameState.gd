extends Node

var currency: float = 50.0:
	get:
		return currency
	set(value):
		currency = value
		if !game_controller: 
			game_controller = get_tree().get_first_node_in_group("game_controller")
		if game_controller:
			game_controller.update_currency_hud()
		
var current_upgrade_levels: Dictionary[ShopConfig.UpgradeID, int] = {}
var game_paused: bool = false
var game_controller: GameController
var config_lookup: Dictionary[CC.ConsumableType, BaseConsumable] = {}
var mass_efficiency: float = 1.0
var stop_spawning_smalls = false

func _ready():
	_load_game_state()
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


func try_purchase(cost: float):
	if currency < cost:
		return false
	
	currency = currency - cost
	return true

func on_consume_increase_currency(amount: float):
	currency += amount * GameState.mass_efficiency

func handle_consume_object(type: CC.ConsumableType, size: float):
	currency += size * mass_efficiency

func player_can_instant_consume(type: CC.ConsumableType):
	if type == CC.ConsumableType.ASTEROID_SM:
		return true
	else:
		return false # TODO: check upgrades to see if you can instant consume
		
func get_consume_rate_per_sec(type: CC.ConsumableType):
	var config: BaseConsumable = config_lookup.get(type) as BaseConsumable
	return (config.consumption_rate_per_sec) * GameState.mass_efficiency # TODO: alter depending on upgrades
	
func gravity_scale_for_type(type):
	if type == CC.ConsumableType.ASTEROID_SM:
		return 1.5
	return 0.1
