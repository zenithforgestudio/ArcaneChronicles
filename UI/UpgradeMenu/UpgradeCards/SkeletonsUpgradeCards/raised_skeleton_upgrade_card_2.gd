extends MarginContainer

var root
var upgrade_menu
var branch_id = 9
var root_branch = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	root.spawn_skeleton_chance = 0.5
	root.enable_upgrade_button(branch_id, 1)
	#upgrade_menu.restack_upgrades()
	upgrade_menu.all_branches[branch_id].pop_back()
	upgrade_menu.close()
	queue_free()
	
	#upgrade_menu.hide()
	#get_tree().paused = false
