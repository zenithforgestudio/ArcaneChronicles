extends MarginContainer

var root
var upgrade_menu
var upgrade_id: int = 0
var branch_id: int = 3
var player
var demon
var level: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")
	player = get_tree().get_first_node_in_group("Player")
	demon = get_tree().get_first_node_in_group("Demon")


func _on_texture_button_pressed() -> void:
	#	Make demon upgrade branch login in upgrade menu
	player.levelUP()
	root.enable_upgrade_button(12, 4)
	player.heal(1)
	upgrade_menu.demon_upgrade_branches[branch_id].remove_at(upgrade_id)
	level = upgrade_menu.get_parent().level
	upgrade_menu.get_parent().update_player_level_text(level + 1)
	upgrade_menu.close()
	upgrade_menu.get_parent().text_label.text = "Level " + str(level)
	if demon:
		demon.animation_player.play("FadeOut")
	get_tree().paused = true
	queue_free()
