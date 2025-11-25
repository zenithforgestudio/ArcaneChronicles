extends MarginContainer

var root
var upgrade_menu
var upgrade_card_id: int = 6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_texture_button_pressed() -> void:
	root.player_spawn_tombstone == true
	root.enable_upgrade_button(12, 2)
	#upgrade_menu.restack_upgrades()
	upgrade_menu.random_upgrades.erase(self)
	upgrade_menu.close()
	queue_free()
	#upgrade_menu.hide()
	#get_tree().paused = false
