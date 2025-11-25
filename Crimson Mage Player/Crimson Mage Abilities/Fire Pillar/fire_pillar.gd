extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var expire_timer: Timer = $ExpireTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var current_enemy: CharacterBody2D
var root
var pool_manager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	pool_manager = get_tree().get_first_node_in_group("Spawner")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if root.fire_pillar_homing == true:
		current_enemy = get_closest_enemy()
		if (self.global_position - current_enemy.global_position).length() < 5:
			current_enemy = get_closest_enemy()
	
		if current_enemy:
			position = position.move_toward(current_enemy.global_position, 30 * delta)
		else:
			current_enemy = get_closest_enemy()

		


func _on_body_entered(body: Node2D) -> void:
	body.take_fire_damage(20, root.fire_ticks)


func _on_expire_timer_timeout() -> void:
	#animation_player.play("FadeAway")
	animated_sprite_2d.play("FireExtinguish")
	await animated_sprite_2d.animation_finished
	return_to_pool()
	
func return_to_pool():
	set_active(false)
	current_enemy = null
	pool_manager.add_fire_pillar_to_pool(self)
	
func set_active(is_active: bool):
	if is_active:
		set_process(true)
		root = get_tree().current_scene
		expire_timer.start(root.fire_pillars_expire_timer - 1)
		set_process(true)
		collision_mask = 2   # Set mask to interact with layer 2
		#animated_sprite_2d.self_modulate.a = 0.5
		show()
		collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("FireStart")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("FireBurn")
		# Ensure the bullet is placed at the correct position when it's activated
		#if position == Vector2.ZERO:
			#position = Vector2(100, 100)  # Set an initial visible position if needed
		#show()  # Show the bullet
		#print("Bullet activated at position: ", position)
	else:
		set_process(false)
		collision_mask = 0   # Disable interaction with any layer
		hide()  # Hide the bullet
		collision_shape_2d.set_deferred("disabled", true)
		#print("Bullet deactivated at position: ", position)

func get_closest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var current_distance = INF
	current_enemy = null
	for enemy in enemies:
		var distance = (enemy.global_position - self.global_position).length()
		if distance < current_distance:
			current_enemy = enemy
			current_distance = distance
	return current_enemy
	
