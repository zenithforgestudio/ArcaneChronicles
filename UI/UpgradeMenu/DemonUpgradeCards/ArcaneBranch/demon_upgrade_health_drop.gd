extends MarginContainer

var root
var upgrade_menu
var upgrade_id: int = 1
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
	root.drop_health_orb_chance += 0.01
	root.enable_upgrade_button(13, 4)
	root.drop_health_orb = true
	upgrade_menu.demon_upgrade_branches[branch_id].remove_at(upgrade_id)
	upgrade_menu.close()
	if demon:
		demon.animation_player.play("FadeOut")
	get_tree().paused = true
	queue_free()
