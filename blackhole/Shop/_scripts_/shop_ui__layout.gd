class_name ShopUI_Layout extends ColorRect

@onready var _node_line_container: Control = $"Node Line Connections"
var _upgrade_nodes: Array[ShopUI_UpgradeNode] = []
var _line_mapping = [] # { from_node: ShopUI_UpgradeNode, to_node: ShopUI_UpgradeNode, line: Line2D }

func _ready():
	var children = get_children()
	for node in children:
		if node is ShopUI_UpgradeNode:
			_upgrade_nodes.append(node as ShopUI_UpgradeNode)
	
	hide_all_tooltips()

func hide_all_tooltips():
	for node in _upgrade_nodes:
		node.hide_tooltip()
		
func on_node_upgraded(upgraded_node, new_unlocks):
	for unlock_id in new_unlocks:
		for unlocked_node: ShopUI_UpgradeNode in _upgrade_nodes:
			if unlocked_node.upgrade_id == unlock_id:
				unlocked_node.show()
				_create_line(upgraded_node, unlocked_node)
	
	_update_line_color_if_both_maxed()

func _update_line_color_if_both_maxed():
	for line in _line_mapping:
		if line.to_node.is_max_level and line.from_node.is_max_level:
			line.line.default_color = Color.YELLOW

func _create_line(from_node: ShopUI_UpgradeNode, to_node: ShopUI_UpgradeNode):
	var new_line = Line2D.new()
	new_line.default_color = Color.WHITE
	new_line.width = 2
	new_line.add_point(from_node.center)
	new_line.add_point(to_node.center)
	_node_line_container.add_child(new_line)
	_line_mapping.append({
		from_node = from_node,
		to_node = to_node,
		line = new_line
	})
