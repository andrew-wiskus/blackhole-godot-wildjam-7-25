class_name ShopCC extends Node

enum UpgradeID {
	GRAVITY_1,
	AOE_1,
	SPEED_1,
	MASS_EFFICENCY_1,
	PASSIVE_MASS_1,
}

const UPGRADE_CONFIG = [
	{
		id = UpgradeID.GRAVITY_1,
		title = "Gravity Go Up",
		button_node_label = "Gv",
		levels = [
			{ value = 0.2, cost = 100, unlocks = [UpgradeID.AOE_1] },
			{ value = 0.3, cost = 300, unlocks = [] },
			{ value = 0.5, cost = 500, unlocks = [UpgradeID.SPEED_1] },
		]
	},
	
	{
		id = UpgradeID.SPEED_1,
		title = "Zoom Zoom",
		button_node_label = "Sp",
		levels = [
			{ value = 1, cost = 500, unlocks = [] },
			{ value = 2, cost = 1000, unlocks = [] },
			{ value = 3, cost = 1500, unlocks = [] },
		]
	},
	
	{
		id = UpgradeID.AOE_1,
		title = "Growth",
		button_node_label = "Sz",
		levels = [
			{ value = 0.2, cost = 500, unlocks = [] },
			{ value = 0.3, cost = 1000, unlocks = [] },
			{ value = 0.4, cost = 1500, unlocks = [] },
			{ value = 0.6, cost = 2500, unlocks = [] },
			{ value = 0.7, cost = 4000, unlocks = [] },
			{ value = 1.5, cost = 10000, unlocks = [] },
		]
	}
]

static func get_upgrade_config(upgrade_id: UpgradeID):
	for config in UPGRADE_CONFIG:
		if config.id == upgrade_id:
			return config

static func get_shop_controller(origin_node: Node) -> ShopController:
	var shop_controller = origin_node.get_tree().get_first_node_in_group("shop_ui_controller")
	return shop_controller as ShopController
	
