extends Area2D

@export var speed: int = 200
@export var drag_factor: float = 6.0  # Adjust for responsiveness (2–10 is good range)

@onready var enemy_detection_area: Area2D = $EnemyDetectionArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var closest_enemy: CharacterBody2D = null
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var pool_manager
var has_collided: bool = false
var player
var damage
var root
var knockBackForce: float = 50
var knockBackTimer: float = 0.2

func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	closest_enemy = find_nearest_enemy()
	if closest_enemy != null:
		closest_enemy.targeted = true
	pool_manager = get_tree().current_scene.get_node("Pool")
	await get_tree().create_timer(0.3).timeout
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if closest_enemy != null and not closest_enemy.dead:
		var desired_direction = (closest_enemy.global_position - global_position).normalized()
		var desired_velocity = desired_direction * speed
		var change = (desired_velocity - velocity) * drag_factor * delta
		velocity += change
		position += velocity * delta
		#look_at(global_position + velocity)

		# Flip sprite based on velocity direction
		animated_sprite_2d.flip_h = velocity.x < 0
	else:
		closest_enemy = find_nearest_enemy()
		if closest_enemy:
			closest_enemy.targeted = true
		else:
			# Drift down when no enemy found
			var desired_velocity = Vector2.DOWN * speed
			var change = (desired_velocity - velocity) * drag_factor * delta
			velocity += change
			position += velocity * delta

func find_nearest_enemy() -> CharacterBody2D:
	var nearest_enemy: CharacterBody2D = null
	var distance = INF
	var bodies = enemy_detection_area.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D and not body.targeted:
			var current_distance = (body.global_position - player.global_position).length() if player != null else (body.global_position - global_position).length()
			if current_distance < distance:
				nearest_enemy = body
				distance = current_distance
	return nearest_enemy

func _on_body_entered(body: Node2D) -> void:
	if has_collided:
		return
	if body.is_in_group("Trap"):
		return
	#if body != closest_enemy:
		#return
	has_collided = true
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

	body.take_damage(
		root.skull_damage + root.bonus_damage,
		root.skull_kill_chance,
		root.chaining_chance,
		self.global_position,
		knockBackForce,
		knockBackTimer,
		root.drop_extra_xp_chance
	)
	
	
	if root.bullet_fire_damage == true:
		body.take_fire_damage(root.bullet_fire_damage_damage, root.fire_ticks)
	
	
	body.targeted = false
	if closest_enemy != null:
		closest_enemy.targeted = false
			
			
			
	await get_tree().process_frame
	return_to_pool()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	return_to_pool()

func return_to_pool():
	set_active(false)
	has_collided = false
	if closest_enemy:
		closest_enemy.targeted = false
	closest_enemy = null
	velocity = Vector2.ZERO
	pool_manager.add_bullet_to_pool(self)

func set_active(is_active: bool):
	if is_active:
		collision_layer = 1
		collision_mask = 2
		if position == Vector2.ZERO:
			position = Vector2(100, 100)
		show()
	else:
		collision_layer = 0
		collision_mask = 0
		hide()
