extends MarginContainer

var root
var upgrade_menu
var upgrade_card_id: int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	root.player_collection_radius += 50
	root.enable_upgrade_button(13, 2)
	root.player.item_collect_collision_shape.shape.radius += 50
	#upgrade_menu.restack_upgrades()
	upgrade_menu.random_upgrades.erase(self)
	upgrade_menu.close()
	queue_free()
	#upgrade_menu.hide()
	#get_tree().paused = false
