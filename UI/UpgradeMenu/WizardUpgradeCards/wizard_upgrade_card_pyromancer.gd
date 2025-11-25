extends MarginContainer

var root
var upgrade_menu
var wizard
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	wizard = get_tree().get_first_node_in_group("WizardNPC")
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")


func _on_texture_button_pressed() -> void:
	root.fire_ticks += 1
	root.volcano_projectiles += 5
	root.enable_upgrade_button(14, 1)
	upgrade_menu.close()
	upgrade_menu.wizzard_upgrades.erase(self)
	wizard.collision_shape_2d.disabled = true
	wizard.animation_player.play("FadeOut")
	queue_free()
