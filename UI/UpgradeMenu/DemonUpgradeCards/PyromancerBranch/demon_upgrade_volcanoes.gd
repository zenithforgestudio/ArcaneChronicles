extends MarginContainer

@onready var texture_button: TextureButton = $UpgradeCard/VBoxContainer/TextureButton


var root
var upgrade_menu
var upgrade_id: int = 1
var branch_id: int = 1
var player: CharacterBody2D
var demon
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")
	demon = get_tree().get_first_node_in_group("Demon")
	player = get_tree().get_first_node_in_group("Player")
	if player.health < 2:
		texture_button.disabled = true
		texture_button.self_modulate.a = 100




func _on_texture_button_pressed() -> void:
#	Make demon upgrade branch login in upgrade menu
	root.enable_upgrade_button(5, 4)
	player.take_damage(1, player.global_position, 0 , 0)
	root.volcano_count += 1
	upgrade_menu.demon_upgrade_branches[branch_id].remove_at(upgrade_id)
	if demon:
		demon.animation_player.play("FadeOut")
	upgrade_menu.close()
	queue_free()
