extends ProgressBar

var player

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#await get_tree().create_timer(0.1).timeout
	#player = get_tree().get_first_node_in_group("Player")
	#player.health_changed.connect(set_size_x)  # Connect the signal once
	#
	## Set initial size and progress based on player's health
	#set_size_x()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func set_size_x():
	#if player:
		## Calculate the desired width
		#var desired_width = get_viewport_rect().size.x - (player.health * 45)
		#
		## Set the progress bar width by adjusting the minimum size
		#custom_minimum_size.x = desired_width
		#
		## Set the progress bar value based on the health (if needed)
		#value = player.health
		#max_value = player.max_health  # Set this to the player's max health
