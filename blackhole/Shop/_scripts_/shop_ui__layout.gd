extends ColorRect

var _upgrade_nodes: Array[ShopUI_UpgradeNode] = []

func _ready():
	var children = get_children()
	for node in children:
		if node is ShopUI_UpgradeNode:
			_upgrade_nodes.append(node as ShopUI_UpgradeNode)
	
	hide_all_tooltips()

func hide_all_tooltips():
	for node in _upgrade_nodes:
		node.hide_tooltip()
