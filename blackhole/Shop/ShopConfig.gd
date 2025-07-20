class_name ShopCC extends Node

enum UpgradeID {
	GRAVITY_1,
	AOE_1,
	SPEED_1,
	MASS_EFFICENCY_1,
	PASSIVE_MASS_1,
	MAX_ZOOM,
	SPEED_2,
	SPEED_3,
	SPEED_4,
}

const UPGRADE_CONFIG = [
	{
		id = UpgradeID.AOE_1,
		title = "Growth",
		button_node_label = "Sz",
		levels = [
			{ value = 1.25, cost = 50, unlocks = [UpgradeID.GRAVITY_1, UpgradeID.SPEED_1] },
			{ value = 1.5, cost = 100, unlocks = [] },
			{ value = 2.0, cost = 200, unlocks = [] },
			{ value = 2.5, cost = 400, unlocks = [] },
			{ value = 3.0, cost = 800, unlocks = [] },
			{ value = 4.0, cost = 1500, unlocks = [] },
			{ value = 5.0, cost = 3000, unlocks = []},
			{ value = 7.0, cost = 5000, unlocks = [] },
			{ value = 10.0, cost = 8000, unlocks = [] },
			{ value = 15.0, cost = 12000, unlocks = [] },
			{ value = 20.0, cost = 18000, unlocks = [] },
			{ value = 25.0, cost = 25000, unlocks = [] },
			{ value = 35.0, cost = 35000, unlocks = [] },
			{ value = 45.0, cost = 50000, unlocks = [] },
			{ value = 55.0, cost = 70000, unlocks = [] },
			{ value = 65.0, cost = 95000, unlocks = [] },
			{ value = 75.0, cost = 125000, unlocks = [] },
			{ value = 85.0, cost = 160000, unlocks = [] },
			{ value = 95.0, cost = 200000, unlocks = [] },
			{ value = 100.0, cost = 250000, unlocks = [] }
		]
	},
	
	{
		id = UpgradeID.GRAVITY_1,
		title = "Gravity Force",
		button_node_label = "Gv",
		levels = [
			{ value = 1.25, cost = 75, unlocks = [UpgradeID.MASS_EFFICENCY_1] },
			{ value = 1.5, cost = 150, unlocks = [] },
			{ value = 2.0, cost = 300, unlocks = [] },
			{ value = 2.5, cost = 600, unlocks = [] },
			{ value = 3.0, cost = 1200, unlocks = [] },
			{ value = 4.0, cost = 2500, unlocks = [] },
			{ value = 5.0, cost = 4500, unlocks = [] },
			{ value = 7.0, cost = 7500, unlocks = [] },
			{ value = 10.0, cost = 12000, unlocks = [] },
			{ value = 15.0, cost = 18000, unlocks = [] },
			{ value = 20.0, cost = 25000, unlocks = [] },
			{ value = 25.0, cost = 35000, unlocks = [] },
			{ value = 35.0, cost = 50000, unlocks = [] },
			{ value = 45.0, cost = 70000, unlocks = [] },
			{ value = 55.0, cost = 95000, unlocks = [] },
			{ value = 65.0, cost = 125000, unlocks = [] },
			{ value = 75.0, cost = 160000, unlocks = [] },
			{ value = 85.0, cost = 200000, unlocks = [] },
			{ value = 95.0, cost = 250000, unlocks = [] },
			{ value = 100.0, cost = 300000, unlocks = [] }
		]
	},
	
	{
		id = UpgradeID.SPEED_1,
		title = "Velocity Boost",
		button_node_label = "Sp",
		levels = [
			{ value = 1.25, cost = 60, unlocks = [UpgradeID.MAX_ZOOM] },
			{ value = 1.5, cost = 120, unlocks = [] },
			{ value = 2.0, cost = 250, unlocks = [] },
			{ value = 2.5, cost = 500, unlocks = [] },
			{ value = 3.0, cost = 1000, unlocks = [UpgradeID.SPEED_2] },
		]
	},
	
		{
		id = UpgradeID.SPEED_2,
		title = "Velocity Boost",
		button_node_label = "Sp",
		levels = [
			{ value = 4.0, cost = 2000, unlocks = [] },
			{ value = 5.0, cost = 4000, unlocks = [] },
			{ value = 7.0, cost = 7000, unlocks = [] },
			{ value = 10.0, cost = 11000, unlocks = [UpgradeID.SPEED_3]  },
		]
	},
			
	
	{
		id = UpgradeID.MASS_EFFICENCY_1,
		title = "Mass Efficiency",
		button_node_label = "Ef",
		levels = [
			{ value = 1.25, cost = 2000, unlocks = [UpgradeID.PASSIVE_MASS_1] },
			{ value = 1.5, cost = 4000, unlocks = [] },
			{ value = 2.0, cost = 8000, unlocks = [] },
			{ value = 2.5, cost = 15000, unlocks = [] },
			{ value = 3.0, cost = 25000, unlocks = [] },
			{ value = 4.0, cost = 40000, unlocks = [] },
			{ value = 5.0, cost = 60000, unlocks = [] },
			{ value = 7.0, cost = 85000, unlocks = [] },
			{ value = 10.0, cost = 115000, unlocks = [] },
			{ value = 15.0, cost = 150000, unlocks = [] },
			{ value = 20.0, cost = 190000, unlocks = [] },
			{ value = 25.0, cost = 240000, unlocks = [] },
			{ value = 35.0, cost = 300000, unlocks = [] },
			{ value = 45.0, cost = 370000, unlocks = [] },
			{ value = 55.0, cost = 450000, unlocks = [] },
			{ value = 65.0, cost = 540000, unlocks = [] },
			{ value = 75.0, cost = 640000, unlocks = [] },
			{ value = 85.0, cost = 750000, unlocks = [] },
			{ value = 95.0, cost = 870000, unlocks = [] },
			{ value = 100.0, cost = 1000000, unlocks = [] }
		]
	},
	
	{
		id = UpgradeID.PASSIVE_MASS_1,
		title = "Passive Mass",
		button_node_label = "Ps",
		levels = [
			{ value = 1.25, cost = 5000, unlocks = [] },
			{ value = 1.5, cost = 10000, unlocks = [] },
			{ value = 2.0, cost = 20000, unlocks = [] },
			{ value = 2.5, cost = 35000, unlocks = [] },
			{ value = 3.0, cost = 55000, unlocks = [] },
			{ value = 4.0, cost = 80000, unlocks = [] },
			{ value = 5.0, cost = 110000, unlocks = [] },
			{ value = 7.0, cost = 145000, unlocks = [] },
			{ value = 10.0, cost = 185000, unlocks = [] },
			{ value = 15.0, cost = 230000, unlocks = [] },
			{ value = 20.0, cost = 280000, unlocks = [] },
			{ value = 25.0, cost = 340000, unlocks = [] },
			{ value = 35.0, cost = 410000, unlocks = [] },
			{ value = 45.0, cost = 490000, unlocks = [] },
			{ value = 55.0, cost = 580000, unlocks = [] },
			{ value = 65.0, cost = 680000, unlocks = [] },
			{ value = 75.0, cost = 790000, unlocks = [] },
			{ value = 85.0, cost = 910000, unlocks = [] },
			{ value = 95.0, cost = 1040000, unlocks = [] },
			{ value = 100.0, cost = 1200000, unlocks = [] }
		]
	},
	{
	id = UpgradeID.MAX_ZOOM,
	title = "Extended Zoom Range",
	button_node_label = "Zm",
	levels = [
		{ value = 1.5, cost = 4000, unlocks = [] },
		{ value = 2.0, cost = 8000, unlocks = [] },
		{ value = 2.5, cost = 15000, unlocks = [] },
		{ value = 3.0, cost = 25000, unlocks = [] },
		{ value = 4.0, cost = 40000, unlocks = [] },
		{ value = 5.0, cost = 60000, unlocks = [] },
		{ value = 7.0, cost = 85000, unlocks = [] },
		{ value = 10.0, cost = 115000, unlocks = [] },
		{ value = 15.0, cost = 150000, unlocks = [] },
		{ value = 20.0, cost = 190000, unlocks = [] },
		{ value = 25.0, cost = 240000, unlocks = [] },
		{ value = 35.0, cost = 300000, unlocks = [] },
		{ value = 45.0, cost = 370000, unlocks = [] },
		{ value = 55.0, cost = 450000, unlocks = [] },
		{ value = 65.0, cost = 540000, unlocks = [] },
		{ value = 75.0, cost = 640000, unlocks = [] },
		{ value = 85.0, cost = 750000, unlocks = [] },
		{ value = 95.0, cost = 870000, unlocks = [] },
		{ value = 100.0, cost = 1000000, unlocks = [] },
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
