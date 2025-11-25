extends Area2D

@export var XP : float = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var player
var direction: Vector2 = Vector2()
var speed = 150
var goToCollect = false
var pool_manager

var this_script  = "xp_drop.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	#set_active(false)
	pool_manager = get_tree().current_scene.get_node("Pool")
	await get_tree().create_timer(0.3).timeout
	player = get_tree().get_first_node_in_group("Player")
	#print(this_script + ": xp drops")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move to player position if entered player collection aura
	if goToCollect == true:
		if visible == true:
			if is_instance_valid(player):
				position = position.move_toward(player.global_position, speed * delta)
			speed += 150 * delta
			if scale > Vector2(0.6, 0.6):
				scale -= Vector2(0.4, 0.4) * delta
	#print(position)

# Destroy and give XP to player
func _on_body_entered(body: Node2D) -> void:
	#print(this_script + ": Xp got")
	if body.is_in_group("Player"):
		body.increasePlayerXP(XP)
		return_to_pool()

func return_to_pool():
	speed = 150
	scale = Vector2(1,1)
	goToCollect = false  # Reset the state so it doesn't keep moving towards the player
	#print("Returning bullet to pool")  # Debug when the bullet is being returned to the pool
	set_active(false)
	pool_manager.add_xp_to_pool(self)

func set_active(is_active: bool):
	if is_active:
		# Set valid collision layer and mask values to interact with other objects
		collision_layer = 4  # Set layer 1 (first layer)
		collision_mask = 1   # Set mask to interact with layer 2
		# Ensure the bullet is placed at the correct position when it's activated
		if position == Vector2.ZERO:
			position = Vector2(100, 100)  # Set an initial visible position if needed
		show()  # Show the bullet
		#print("Bullet activated at position: ", position)
	else:
		# Deactivate bullet and prevent it from interacting with other objects
		collision_layer = 0  # Disable layer interaction
		collision_mask = 0   # Disable interaction with any layer
		hide()  # Hide the bullet


# Trigger the collection logic when entering the collection area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collection"):
		if !goToCollect:  # Only start moving if it's not already in motion
			goToCollect = true
