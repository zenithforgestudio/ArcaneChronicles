extends TextureProgressBar

@onready var canvas_layer: CanvasLayer = $"../../../.."

var worldManager
var player
var upgrade_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")
	player = get_tree().get_first_node_in_group("Player")
	worldManager = get_tree().current_scene
	
	# Set the initial max_value based on player's level
	max_value = 5  # Initial XP required for level 1
	
	# Connect the XP gained signal
	if is_instance_valid(player):
		player.XP_gained.connect(update_xp)  # Connect the signal to update xp
		update_xp(player.playerXP)  # Initialize the XP UI based on current player XP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Handle XP update
func update_xp(xp: int):
	value = xp  # Set the current XP value
	
	# Level up check
	if value >= max_value:  # If XP exceeds or equals the max value
		
		player.levelUP()
		player.playerXP = 0
		value -= max_value  # Reset XP to 0
		player.level += 1  # Increase the player's level
		canvas_layer.update_player_level_text(player.level)
		get_tree().paused = true
		#print("Level Up! New Level: ", player.level)
		#if worldManager.skullsNumber < 5:
			#worldManager.skullsNumber += 1
		#if worldManager.orbitting_skulls_number < 0:
			#worldManager.orbitting_skulls_number += 1
			#worldManager.orbitting_skulls_number_changed.emit(worldManager.orbitting_skulls_number)
		
		
		# Update max_value for exponential growth (doubling the required XP)
		#max_value = 5 * player.level
		max_value = max_value + int(max_value / 3)
