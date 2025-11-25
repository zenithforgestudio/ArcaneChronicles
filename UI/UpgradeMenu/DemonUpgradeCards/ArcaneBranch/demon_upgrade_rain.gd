extends MarginContainer

@onready var texture_button: TextureButton = $UpgradeCard/VBoxContainer/TextureButton

var root
var upgrade_menu
var upgrade_id: int = 3
var branch_id: int = 0
var player
var demon


func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	demon = get_tree().get_first_node_in_group("Demon")
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")
	player = get_tree().get_first_node_in_group("Player")
	if player.health < 2:
		texture_button.disabled = true
		texture_button.self_modulate.a = 100


func _on_texture_button_pressed() -> void:
	#	Make demon upgrade branch login in upgrade menu
	root.enable_upgrade_button(2, 4)
	player.take_damage(1, player.global_position, 0 , 0)
	player.bone_rain.length = get_viewport_rect().size.x / 1.0
	player.bone_rain.height = get_viewport_rect().size.y / 1.0
	root.rain_drops += 30
	upgrade_menu.demon_upgrade_branches[branch_id].remove_at(upgrade_id)
	upgrade_menu.close()
	if demon:
		demon.animation_player.play("FadeOut")
	queue_free()
