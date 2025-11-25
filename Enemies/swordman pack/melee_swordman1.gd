extends CharacterBody2D  # Use CharacterBody2D instead of StaticBody2D

@export var speed: int = 50
@export var health : int = 300
@export var speed_multiplier : float = 1.05
@export var hit_distance: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var chain_weight: Node2D = $ChainWeight
@onready var chain_timer: Timer = $ChainTimer
@onready var label: Label = $Label
@onready var fire_ticks_timer: Timer = $FireTicksTimer
@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var fire_animation_2: AnimatedSprite2D = $FireAnimation2
#@onready var take_damage_label: Label = $TakeDamageLabel
#@onready var take_fire_damage_label: Label = $TakeDamageLabel2

var pool_manager
var xp_pool_manager
var player: CharacterBody2D
var dead = false
var targeted = false
var base_speed = 50
var root_node
var spawn_chance
var closest_skeleton : CharacterBody2D = null
var closest_distance = INF
var current_target: CharacterBody2D
var chained : bool = false
var state = EnemyState.IDLE
var direction
var burned: bool = false
var flame_targeted: bool = false
var knockBackDirection 
var knockBackForce 
var knockBackTimer 
var attackKnockBackForce: int = 200
var attackKnockBackTimer: float = 0.2
var handTargeted: bool = false
var currentTarget: CharacterBody2D = null
var grabbed: bool = false
var attacking: bool = false

var currentFireTicks: int = 0
var currentFireDamage: int = 0

enum EnemyState {IDLE, CHASING, ATTACKING, CHAINED, DEAD, TAKING_DAMAGE}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get player
	
	await get_tree().process_frame
	pool_manager = get_tree().get_first_node_in_group("Spawner")
	xp_pool_manager = get_tree().get_first_node_in_group("pool")
	player = get_tree().get_first_node_in_group("Player")
	root_node = get_tree().current_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#label.text = str(targeted)
	
	if health <= 0:
		state = EnemyState.DEAD
	
	#if state != EnemyState.ATTACKING:
		#currentTarget = get_closest_target()
		
	currentTarget = get_closest_entitiy()
	
	#match state:
		#EnemyState.IDLE:
			#animated_sprite_2d.play("Idle")
			#velocity = Vector2.ZERO
			#if player and player.health > 0 and health > 0:
				#state = EnemyState.CHASING
		#EnemyState.CHASING:
			#animated_sprite_2d.play("Walk")
			#
			#if player == null or player.health <= 0:
				#state = EnemyState.IDLE
			#else:
				#direction = player.global_position - global_position
				#if direction.length() <= hit_distance:
					#state = EnemyState.ATTACKING
				#else:
					#velocity = direction.normalized() * speed
		#EnemyState.ATTACKING:
			#velocity = Vector2.ZERO
			#if player.health > 0:
				#animated_sprite_2d.play("Attack")
				#await get_tree().create_timer(0.3).timeout
				#player.take_damage(1, global_position, 
									#attackKnockBackForce, attackKnockBackTimer)
				#await animated_sprite_2d.animation_finished
				#state = EnemyState.CHASING
		#EnemyState.CHAINED:
			#chained = true
			#animated_sprite_2d.play("Idle")
			#velocity = Vector2.ZERO
			#chain_weight.show()
			#if chained:
				#if animated_sprite_2d.flip_h == false:
					#chain_weight.position.x = -16
					#fire_animation.position.x = -6
					#fire_animation.flip_h = false
					#fire_animation_2.position = Vector2(5, 0)
					#fire_animation.flip_h = true
					#chain_weight.show_chains_right()
				#else:
					#chain_weight.position.x = 30
					#fire_animation.position.x = 17
					#fire_animation.flip_h = true
					#fire_animation_2.flip_h = true
					#chain_weight.show_chains_left()
		#EnemyState.DEAD:
			#velocity = Vector2.ZERO
			
	match state:
		EnemyState.IDLE:
			animated_sprite_2d.play("Idle")
			velocity = Vector2.ZERO
			if is_instance_valid(player) and player.health > 0 and health > 0:
				state = EnemyState.CHASING
		EnemyState.CHASING:
			animated_sprite_2d.play("Walk")
			
			if player == null or player.health <= 0:
				state = EnemyState.IDLE
			else:
				if currentTarget:
					direction = currentTarget.global_position - global_position
					if direction.length() <= hit_distance:
						state = EnemyState.ATTACKING
					else:
						velocity = direction.normalized() * speed
				else:
					velocity = Vector2(1, 0).normalized() * speed

		EnemyState.ATTACKING:
			velocity = Vector2.ZERO
			if player.health > 0:
				if attacking == false:
					attacking = true
					animated_sprite_2d.play("Attack")
					await get_tree().create_timer(0.3).timeout
					if currentTarget and (currentTarget.global_position - self.global_position).length() < (hit_distance + 10) or (currentTarget.is_in_group("Player") and (player.global_position - self.global_position).length() < hit_distance):
						currentTarget.take_damage(1, self.global_position, 
											attackKnockBackForce, attackKnockBackTimer)
					await animated_sprite_2d.animation_finished
					attacking = false
					state = EnemyState.IDLE
		EnemyState.CHAINED:
			chained = true
			animated_sprite_2d.play("Idle")
			velocity = Vector2.ZERO
			chain_weight.show()
			if chained:
				if animated_sprite_2d.flip_h == false:
					chain_weight.position.x = -16
					fire_animation.position.x = -6
					fire_animation.flip_h = false
					fire_animation_2.position = Vector2(5, 0)
					fire_animation.flip_h = true
					chain_weight.show_chains_right()
				else:
					chain_weight.position.x = 30
					fire_animation.position.x = 17
					fire_animation.flip_h = true
					fire_animation_2.flip_h = true
					chain_weight.show_chains_left()
		EnemyState.DEAD:
			velocity = Vector2.ZERO
			
	if state != EnemyState.DEAD:
		if knockBackTimer and knockBackTimer > 0.0:
			velocity = knockBackForce * knockBackDirection
			knockBackTimer -= delta
			if knockBackTimer <= 0.0:
				velocity = Vector2.ZERO
			
	move_and_slide()

			# Flip sprite based on movement direction
	if health > 0 and currentTarget:
		if currentTarget.global_position.x < global_position.x:
			animated_sprite_2d.flip_h = true
			fire_animation.position.x = 17
			fire_animation.flip_h = true
			fire_animation_2.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
			fire_animation.position.x = -6
			fire_animation.flip_h = false
			fire_animation.flip_h = true
# Take damage


func get_closest_target() -> CharacterBody2D:
	if is_instance_valid(player) and player.health > 0:
		if closest_skeleton == null:
			closest_skeleton = get_closest_skeleton()
		if closest_skeleton and closest_skeleton.health > 0 and closest_skeleton.raised == true:
			var distance_to_skeleton = (self.global_position - closest_skeleton.global_position).length()
			var distance_to_player = (self.global_position - player.global_position).length()
			
			if distance_to_skeleton < distance_to_player * 2:
				currentTarget = closest_skeleton
			else:
				currentTarget = player
		else:
			currentTarget = player
	else:
		currentTarget = null
		
	return currentTarget

func take_damage(damage: int, insta_death_chance: float, chaining_chance: float, 
				knockBackPosition: Vector2, KnockBackForce, KnockBackTimer, drop_extra_xp_chance: float):
	if dead:
		return 
	state = EnemyState.TAKING_DAMAGE
	if KnockBackForce > 0:
		knockBackDirection = (global_position - knockBackPosition).normalized()
		knockBackForce = KnockBackForce 
		knockBackTimer = KnockBackTimer
	var rng = randf_range(0, 1)
	var rng2 = randf_range(0, 1)
	if root_node == null:
		root_node = get_tree().current_scene
	if rng < root_node.skull_kill_chance:
		health = 0
	else:
		if root_node.chaining_damage and chained:
			health -= 1.25 * damage
		else:
			health -= damage
		if pool_manager == null:
			pool_manager = get_tree().get_first_node_in_group("Spawner")
		if pool_manager.has_method("spawn_label"):
			var take_damage_label = pool_manager.spawn_label(self)
			take_damage_label.position.y = position.y - 25
			if root_node.chaining_damage and chained:
				take_damage_label.show_damage(1.25 * damage)
			else:	
				take_damage_label.show_damage(damage)
	targeted = false
	animation_player.play("HitFlash")


	if health <= 0:
		burned = false
		state = EnemyState.DEAD
		fire_animation.hide()
		fire_animation_2.hide()
		if root_node.has_method("increment_kills"):
			root_node.increment_kills()
		dead = true
		velocity = Vector2.ZERO
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Die")  # Play "Die" animation after hit
		call_deferred("add_xp", self.global_position)
		if root_node.chain_extra_xp == true and chained:
			call_deferred("add_xp", self.global_position + Vector2(20, 0))
		var extra_xp_rng = randf_range(0, 1)
		if extra_xp_rng < drop_extra_xp_chance:
			call_deferred("add_xp", self.global_position + Vector2(-20, 0))
			
		var drop_health_orb_rng = randf_range(0, 1)
		if drop_health_orb_rng < root_node.drop_health_orb_chance and root_node.drop_health_orb == true:
			pool_manager.call_deferred("spawn_health_orb", self.global_position)
			root_node.drop_health_orb_chance = 0.01
		disable_collision()
		await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
		#animated_sprite_2d.play("Stay_Dead")
		animation_player.play("FadeOut")  # Play fade out animation
		await animation_player.animation_finished  # Wait for fade-out animation to finish
		if pool_manager.has_method("spawn_skeleton"):
			spawn_chance = randf_range(0,1)
			if spawn_chance < root_node.spawn_skeleton_chance:
				pool_manager.spawn_skeleton(global_position)
		targeted = false
		queue_free()
		
	elif rng2 <= chaining_chance and health > 0:
		state = EnemyState.CHAINED
		chain_timer.start(root_node.chaining_duration)
			
	else:
		if health > 0 and chained == false and health > 0:
			state = EnemyState.CHASING
	
func take_fire_damage(fire_damage: int, ticks: int):
	if dead or health < 0:
		return
	flame_targeted = false
	var fireTicksCopy = currentFireTicks
	currentFireTicks += ticks
	currentFireDamage = max(currentFireDamage, fire_damage)
	burned = true
	if (state != EnemyState.DEAD):
		fire_animation.show()
		fire_animation_2.show()
	for i in range(ticks + fireTicksCopy):
		if burned == true:
			currentFireTicks -= 1
			health -= max(fire_damage, currentFireDamage)
			if pool_manager == null:
				pool_manager = get_tree().get_first_node_in_group("Spawner")
			if pool_manager.has_method("spawn_label"):
				var take_fire_damage_label = pool_manager.spawn_label(self)
				take_fire_damage_label.position.y = position.y -25
				take_fire_damage_label.show_fire_damage(fire_damage)
		if health <= 0:
			state = EnemyState.DEAD
			fire_animation.hide()
			fire_animation_2.hide()
			if animated_sprite_2d.animation != "Die":
				if root_node.has_method("increment_kills"):
					root_node.increment_kills()
				dead = true
				velocity = Vector2.ZERO
				animated_sprite_2d.stop()
				animated_sprite_2d.play("Die")  # Play "Die" animation after hit
				call_deferred("add_xp", self.global_position)
				if root_node.chain_extra_xp == true:
					call_deferred("add_xp", self.global_position + Vector2(20, 0))
				disable_collision()
				await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
				#animated_sprite_2d.play("Stay_Dead")
				animation_player.play("FadeOut")  # Play fade out animation
				targeted = false
				await animation_player.animation_finished  # Wait for fade-out animation to finish
				if pool_manager.has_method("spawn_skeleton"):
					spawn_chance = randf_range(0,1)
					if spawn_chance < root_node.spawn_skeleton_chance:
						pool_manager.spawn_skeleton(global_position)
				var drop_health_orb_rng = randf_range(0, 1)
				if drop_health_orb_rng < root_node.drop_health_orb_chance and root_node.drop_health_orb == true:
					pool_manager.call_deferred("spawn_health_orb", self.global_position)
					root_node.drop_health_orb_chance = 0.01
				queue_free()
				

		animated_sprite_2d.self_modulate = Color("#ff8274")
		fire_ticks_timer.start(0.2)
		await fire_ticks_timer.timeout
		animated_sprite_2d.self_modulate = Color("#ffffff")
		fire_ticks_timer.start(0.8)
		await fire_ticks_timer.timeout
	currentFireDamage = 0
	currentFireTicks = 0
	burned = false
	targeted = false
	fire_animation.hide()
	fire_animation_2.hide()

		
		
#func _on_fire_ticks_timer_timeout() -> void:
	#pass # Replace with function body.

# Disable collision
func disable_collision():
	collision_shape_2d.set_deferred("disabled", true)
	
func add_xp(pos):
	if xp_pool_manager != null:
		var xp = xp_pool_manager.get_xp()
		if xp != null:
			get_parent().add_child(xp)  # Re-add xp to the world
			xp.global_position = pos  # Set spawn position
			xp.set_active(true)  # Reactivate xp if necessary
		

		

func get_closest_skeleton() -> CharacterBody2D:
	var skeletons = get_tree().get_nodes_in_group("Skeleton")
	closest_skeleton = null
	closest_distance = INF
	for skeleton in skeletons:
		if skeleton is CharacterBody2D:
			if (skeleton.global_position - global_position).length() < closest_distance and skeleton.health > 0:
				closest_distance = (skeleton.global_position - global_position).length()
				closest_skeleton = skeleton
	return closest_skeleton

func set_grabbed():
	if grabbed == false:
		grabbed = true
		targeted = true
		set_deferred("collision_shape_2d.disabled", true)
		#disable_collision()
		handTargeted = true
		state = EnemyState.DEAD
		animated_sprite_2d.play("Idle")
		await animated_sprite_2d.frame_changed
		animated_sprite_2d.stop()
		animation_player.play("FadeOut")  # Play fade out animation
		fire_animation.hide()
		fire_animation_2.hide()
		burned = false
		disable_collision()

		for i in range(20):
			await get_tree().create_timer(0.1).timeout
			self.global_position.y += 3
		#await get_tree().create_timer(1).timeout
		hide()
		if root_node.skeleton_hands_spawn_grave == true:
			pool_manager.spawn_tombstone(self.global_position, animated_sprite_2d.flip_h)
		take_damage(health, 0, 0, self.global_position, 0, 0, root_node.drop_extra_xp_chance)

	
func get_closest_entitiy() -> CharacterBody2D:
	var skeleton = get_closest_skeleton()
	if skeleton == null:
		return player
	else:
		return get_closest_target()

func _on_chain_timer_timeout() -> void:
	chain_weight.hide()
	chained = false
	if state != EnemyState.DEAD:
		state = EnemyState.CHASING


#func _on_chain_damage_timer_timeout() -> void:
	#if chained == true and root_node.chaining_damage > 0:
		#take_damage(root_node.chaining_damage, 0, 0, Vector2.ZERO, 0, 0)
