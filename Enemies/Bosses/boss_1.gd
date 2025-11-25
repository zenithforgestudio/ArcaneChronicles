extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var fire_animation_2: AnimatedSprite2D = $FireAnimation2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_ticks_timer: Timer = $FireTicksTimer
@onready var label: Label = $Label
@onready var atack_timer: Timer = $AtackTimer

@onready var stab_collision_area: CollisionShape2D = $StabArea/StabCollisionArea
@onready var thorns_collision_area: CollisionShape2D = $ThornsArea/ThornsCollisionArea



var speed = 120
var player: CharacterBody2D
var direction 
var state
var targeted: bool = false
var dead: bool = false
var knockBackDirection
var knockBackForce
var knockBackTimer
var root_node
var health = 10000
var pool_manager
var burned
var hit_distace = 50
var cage
var attackKnockBackForce = 100
var attackKnockBackTimer = 0.5
var attacking: bool = false
var NumberAttacks: int = 0
var flame_targeted: bool = false
var currentFireTicks: int = 0
var currentFireDamage: int = 0
var spawned_crystal: bool = false
var handTargeted: bool = false
var crystal = preload("res://Pixel Environment/crystal.tscn")

enum EnemyState {IDLE, CHASING, ATTACKING, DEAD, TAKING_DAMAGE, SPAWNING}

func _ready() -> void:
	await get_tree().process_frame
	stab_collision_area.disabled = true
	thorns_collision_area.disabled = true
	state = EnemyState.SPAWNING
	root_node = get_tree().current_scene
	player = get_tree().get_first_node_in_group("Player")
	pool_manager = get_tree().get_first_node_in_group("Spawner")
	await animated_sprite_2d.animation_finished
	state = EnemyState.IDLE
	

func _physics_process(delta: float) -> void:
	if dead:
		return
		
	label.text = str(health)
	
	match state:
		EnemyState.IDLE:
			if is_instance_valid(player) and player.health > 0:
				state = EnemyState.CHASING
			else:
				state = EnemyState.IDLE
		EnemyState.CHASING:
			animated_sprite_2d.play("Run")
			
			if player == null or player.health <= 0:
				state = EnemyState.IDLE
			else:
				if is_instance_valid(player):
					direction = (player.global_position - global_position)
					if abs(player.global_position.x - self.global_position.x) <= hit_distace and abs(player.global_position.y - self.global_position.y) <= 20:
						state = EnemyState.ATTACKING
					else:
						velocity = direction.normalized() * speed 
		EnemyState.ATTACKING:
			if attacking == false:
				attacking = true
				attack()
		EnemyState.TAKING_DAMAGE:
			pass
			
			
	if state != EnemyState.DEAD:
		if knockBackTimer and knockBackTimer > 0.0:
			velocity = knockBackForce * knockBackDirection
			knockBackTimer -= delta
			if knockBackTimer <= 0.0:
				velocity = Vector2.ZERO
			
	if is_instance_valid(player):
		if player.global_position.x < self.global_position.x:
			animated_sprite_2d.flip_h = true
			stab_collision_area.position.x = -stab_collision_area.position.x
			fire_animation.flip_h = true
			fire_animation.position.x = 0.5
			fire_animation_2.flip_h = true
			fire_animation.position.x = -2.5
		else:
			animated_sprite_2d.flip_h = false
			stab_collision_area.position.x = -stab_collision_area.position.x
			fire_animation.flip_h = false
			fire_animation.position.x = -0.5
			fire_animation_2.flip_h = false
			fire_animation_2.position.x = 2.5
	else:
		player = get_tree().get_first_node_in_group("Player")
		
	
	move_and_slide()

func take_damage(damage: int, insta_death_chance: float, chaining_chance: float, 
				knockBackPosition: Vector2, KnockBackForce, KnockBackTimer, drop_extra_xp_chance: float):
	if dead:
		return 
		
	if health <= 0:
		health = 0
		dead = true
		return
	if state != EnemyState.ATTACKING:
		state = EnemyState.TAKING_DAMAGE
	

	
	if KnockBackForce > 0:
		knockBackDirection = (global_position - knockBackPosition).normalized()
		knockBackForce = KnockBackForce / 10
		knockBackTimer = KnockBackTimer / 10
		
	var blockChance = randf_range(0, 1)
	if blockChance < 0.35 and state == EnemyState.TAKING_DAMAGE:
		animated_sprite_2d.play("Block2")
		await animated_sprite_2d.animation_finished
		state = EnemyState.CHASING
		return
		
	health -= damage
	if pool_manager.has_method("spawn_label"):
		var take_damage_label = pool_manager.spawn_label(self)
		take_damage_label.position.y = position.y - 25
		take_damage_label.show_damage(damage)
	targeted = false
	animation_player.play("HitFlash")
	if state != EnemyState.ATTACKING and state != EnemyState.DEAD and health > 0:
		state = EnemyState.CHASING

	if health <= 0:
		health = 0
		burned = false
		state = EnemyState.DEAD
		fire_animation.hide()
		fire_animation_2.hide()
		dead = true
		velocity = Vector2.ZERO
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Die")  # Play "Die" animation after hit
		await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
		#animated_sprite_2d.play("Stay_Dead")
		animation_player.play("FadeOut")  # Play fade out animation
		await animation_player.animation_finished  # Wait for fade-out animation to finish
		if spawned_crystal == false:
			spawned_crystal = true
			var crystal_instance = crystal.instantiate()
			crystal_instance.global_position = self.global_position
			root_node.add_child(crystal_instance)
		var cage = get_tree().get_first_node_in_group("Cage")
		cage.clear_cage()
		cage.spawner.start_timers()
		for child in get_children():
			if child is Label and child.has_method("return_to_pool"):
				child.return_to_pool()
		pool_manager.boss_timer_2.start(250)
		queue_free()
		return
		
	
func take_fire_damage(fire_damage: int, ticks: int):
	if health <= 0:
		health = 0
		return
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
			health -= fire_damage
			if pool_manager.has_method("spawn_label"):
				var take_fire_damage_label = pool_manager.spawn_label(self)
				take_fire_damage_label.position.y = position.y -25
				take_fire_damage_label.show_fire_damage(fire_damage)
			animated_sprite_2d.self_modulate = Color("#ff8274")
			fire_ticks_timer.start(0.2)
			await fire_ticks_timer.timeout
			animated_sprite_2d.self_modulate = Color("#ffffff")
			fire_ticks_timer.start(0.8)
			await fire_ticks_timer.timeout

		
		
		if health <= 0 and state != EnemyState.DEAD:
			health = 0
			state = EnemyState.DEAD
			dead = true
			targeted = false
			burned = false
			state = EnemyState.DEAD
			fire_animation.hide()
			fire_animation_2.hide()
			velocity = Vector2.ZERO
			animated_sprite_2d.stop()
			if animated_sprite_2d.animation != "Die":
				animated_sprite_2d.play("Die")  # Play "Die" animation after hit
			await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
			animation_player.play("FadeOut")  # Play fade out animation
			await animation_player.animation_finished
			if spawned_crystal == false:
				spawned_crystal = true
				var crystal_instance = crystal.instantiate()
				crystal_instance.global_position = self.global_position
				root_node.add_child(crystal_instance)
			var cage = get_tree().get_first_node_in_group("Cage")
			cage.clear_cage()
			cage.spawner.start_timers()
			pool_manager.boss_timer_2.start(250)
			queue_free()
			return
	currentFireDamage = 0
	currentFireTicks = 0



func attack():
	state = EnemyState.ATTACKING
	velocity = Vector2.ZERO
	animated_sprite_2d.play("StabAttack")
	await get_tree().create_timer(0.7).timeout
	stab_collision_area.disabled = false
	await animated_sprite_2d.animation_finished
	stab_collision_area.disabled = true
	#if NumberAttacks < 2:
		#NumberAttacks += 1
		#animated_sprite_2d.play("StabAttack")
		#await get_tree().create_timer(0.7).timeout
		#stab_collision_area.disabled = false
		#await animated_sprite_2d.animation_finished
		#stab_collision_area.disabled = true
	#else:
		#NumberAttacks = 0
		#animated_sprite_2d.play("SideWayThorns")
		#await get_tree().create_timer(0.5).timeout
		#thorns_collision_area.disabled = false
		#await animated_sprite_2d.animation_finished
		#thorns_collision_area.disabled = true
		#
	await get_tree().create_timer(0.5).timeout
	attacking = false
	state = EnemyState.CHASING
	

func stab_attack():
	pass
	
func thorns_attack():
	pass


func _on_stab_area_body_entered(body: Node2D) -> void:
	body.take_damage(1, self.global_position, attackKnockBackForce, attackKnockBackTimer)


func _on_thorns_area_body_entered(body: Node2D) -> void:
	body.take_damage(1, self.global_position, attackKnockBackForce, attackKnockBackTimer)
	


func _on_atack_timer_timeout() -> void:
	attack()
	atack_timer.start(randf_range(2, 4))

func set_grabbed():
	take_damage(100, 0, 0, self.global_position, 0, 0, 0)


func _on_player_collision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1, self.global_position, attackKnockBackForce, attackKnockBackTimer)
