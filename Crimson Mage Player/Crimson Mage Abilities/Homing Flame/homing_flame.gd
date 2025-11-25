extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player
var root
var speed
var closest_enemy: CharacterBody2D = null
var direction: Vector2 = Vector2.ZERO
var pillar = preload("res://Crimson Mage Player/Crimson Mage Abilities/Fire Pillar/fire_pillar.tscn")
var pool

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	root = get_tree().current_scene
	speed = root.homing_flame_speed
	closest_enemy = find_nearest_enemy()
	pool = get_tree().get_first_node_in_group("Spawner")
	if closest_enemy:
		closest_enemy.flame_targeted = true

func _process(delta: float) -> void:
	if player == null:
		return
	
	# Refresh closest_enemy if needed
	if closest_enemy == null or closest_enemy.dead or closest_enemy.burned:
		closest_enemy = find_nearest_enemy()
		if closest_enemy:
			closest_enemy.flame_targeted = true

	if closest_enemy != null:
		var target_direction = closest_enemy.global_position - global_position
		position = position.move_toward(closest_enemy.global_position, speed * delta)
		
		# Flip sprite based on direction
		animated_sprite_2d.flip_h = target_direction.x < 0
	else:
		# No target, hover near player
		position = position.move_toward(player.global_position + Vector2(0, -50), speed * delta)

func find_nearest_enemy() -> CharacterBody2D:
	var nearest_enemy : CharacterBody2D = null
	var min_distance = INF
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	for body in enemies:
		if body is CharacterBody2D and not body.burned and body.health > 0 and not body.flame_targeted:
			var dist = (body.global_position - global_position).length()
			if dist < min_distance:
				nearest_enemy = body
				min_distance = dist
	
	return nearest_enemy

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_fire_damage"):
		body.take_fire_damage(root.homing_flame_damage, root.fire_ticks)
		if "burned" in body:
			body.burned = true
		if "flame_targeted" in body:
			body.flame_targeted = false
	
	# Immediately find and target another enemy
	closest_enemy = find_nearest_enemy()
	if closest_enemy:
		closest_enemy.flame_targeted = true


func _on_timer_timeout() -> void:
	if root.homing_flame_spawn_pillar == true:
		pool.spawn_pillar(self.global_position)
