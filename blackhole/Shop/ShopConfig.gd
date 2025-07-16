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
			{ value = 2.0, cost = 20, unlocks = [UpgradeID.AOE_1] },
			{ value = 4.0, cost = 30, unlocks = [] },
			{ value = 6.0, cost = 100, unlocks = [UpgradeID.SPEED_1] },
		]
	},
	
	{
		id = UpgradeID.SPEED_1,
		title = "Zoom Zoom",
		button_node_label = "Sp",
		levels = [
			{ value = 1.33, cost = 50, unlocks = [] },
			{ value = 1.66, cost = 100, unlocks = [] },
			{ value = 2.00, cost = 250, unlocks = [] },
		]
	},
	
	{
		id = UpgradeID.AOE_1,
		title = "Growth",
		button_node_label = "Sz",
		levels = [
			{ value = 1.2, cost = 50, unlocks = [] },
			{ value = 1.3, cost = 100, unlocks = [] },
			{ value = 1.4, cost = 150, unlocks = [] },
			{ value = 1.6, cost = 250, unlocks = [] },
			{ value = 2.0, cost = 400, unlocks = [] },
			{ value = 2.5, cost = 1000, unlocks = [] },
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
	
