extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var player
var direction: Vector2 = Vector2()
var speed = 100
var goToCollect = false
var pool_manager

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
			speed += 100 * delta
	#print(position)

# Destroy and give XP to player
func _on_body_entered(body: Node2D) -> void:
	#print(this_script + ": Xp got")
	if body.is_in_group("Player"):
		body.heal(1)
		queue_free()
		
# Trigger the collection logic when entering the collection area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collection"):
		if !goToCollect:  # Only start moving if it's not already in motion
			goToCollect = true
