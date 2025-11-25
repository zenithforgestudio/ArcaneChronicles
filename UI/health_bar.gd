extends HBoxContainer


var heart_scene = preload("res://UI/heart_point.tscn")
var player
var root

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	player = get_tree().get_first_node_in_group("Player")
	root = get_tree().current_scene
	
	#set player health
	if is_instance_valid(player):
		player.health_changed.connect(update_hearts)  # Connect the signal
		update_hearts(player.health)  # Initialize UI

func update_hearts(new_health: int):
	# Properly remove old hearts
	var current_hearts = get_child_count()
	
	if new_health < current_hearts and current_hearts > 0:
		var last_heart = get_child(current_hearts - 1)
		last_heart.crack_heart()
		await get_tree().create_timer(0.75).timeout
	
	for child in get_children():
		remove_child(child)
		child.queue_free()

	await get_tree().process_frame  # Ensure UI updates properly

	# Add new hearts
	for i in range(new_health):
		var heart_instance = heart_scene.instantiate()
		add_child(heart_instance)

	await get_tree().process_frame  # Ensure UI updates properly
	if new_health <= 0:
		get_tree().current_scene.hide_pause_button()
		#animation_player.play("you_died_appear")


func _on_heal_player_timer_timeout() -> void:
	if root.heal_player == true:
		update_hearts(player.health + 1)
