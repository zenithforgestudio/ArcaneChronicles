#extends CharacterBody2D
#
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var fire_animation: AnimatedSprite2D = $FireAnimation
#@onready var fire_animation_2: AnimatedSprite2D = $FireAnimation2
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var fire_ticks_timer: Timer = $FireTicksTimer
#@onready var label: Label = $Label
#@onready var marker_2d: Marker2D = $Marker2D
#
#const SPIRIT_SUMMON = preload("res://Enemies/spirit_summon.tscn")
#
#var speed = 125
#var player: CharacterBody2D
#var direction 
#var state
#var targeted: bool = false
#var dead: bool = false
#var knockBackDirection
#var knockBackForce
#var knockBackTimer
#var root_node
#var health = 15000
#var pool_manager
#var burned
#var hit_distace = 70
#var cage
#var attackKnockBackForce = 100
#var attackKnockBackTimer = 0.5
#var attacking: bool = false
#var NumberAttacks: int = 0
#var flame_targeted: bool = false
#var currentFireTicks: int = 0
#var currentFireDamage: int = 0
#var handTargeted: bool = false
#var truly_dead: bool = false
#
#
#enum EnemyState {IDLE, CHASING, ATTACKING, DEAD, TAKING_DAMAGE, SPAWNING, SPAWN_SPIRIT}
#
#func _ready() -> void:
	#await get_tree().process_frame
	#state = EnemyState.SPAWNING
	#root_node = get_tree().current_scene
	#player = get_tree().get_first_node_in_group("Player")
	#pool_manager = get_tree().get_first_node_in_group("Spawner")
	#await animated_sprite_2d.animation_finished
	#state = EnemyState.IDLE
	#
#
#func _physics_process(delta: float) -> void:
	#
	#label.text = str(health)
	#
	#match state:
		#EnemyState.IDLE:
			#if player and player.health > 0:
				#state = EnemyState.CHASING
			#else:
				#state = EnemyState.IDLE
		#EnemyState.CHASING:
			#animated_sprite_2d.play("Idle2")
			#
			#if player == null or player.health <= 0:
				#state = EnemyState.IDLE
			#else:
				#if player:
					#direction = (player.global_position - global_position)
					#if abs(player.global_position.x - self.global_position.x) <= hit_distace and abs(player.global_position.y - self.global_position.y) <= 20:
						#state = EnemyState.ATTACKING
					#else:
						#velocity = direction.normalized() * speed 
		#EnemyState.ATTACKING:
			#if attacking == false:
				#attacking = true
				#attack()
		#EnemyState.TAKING_DAMAGE:
			#pass
			#
			#
	#if state != EnemyState.DEAD:
		#if knockBackTimer and knockBackTimer > 0.0:
			#velocity = knockBackForce * knockBackDirection
			#knockBackTimer -= delta
			#if knockBackTimer <= 0.0:
				#velocity = Vector2.ZERO
			#
	#if player:
		#if player.global_position.x < self.global_position.x:
			#animated_sprite_2d.flip_h = true
			#fire_animation.flip_h = true
			#fire_animation.position.x = 9
			#fire_animation_2.flip_h = true
			#fire_animation.position.x = -3
			#marker_2d.position.x = -30
		#else:
			#animated_sprite_2d.flip_h = false
			#fire_animation.flip_h = false
			#fire_animation.position.x = -9
			#fire_animation_2.flip_h = false
			#fire_animation_2.position.x = 3
			#marker_2d.position.x = 30
	#else:
		#player = get_tree().get_first_node_in_group("Player")
		#
	#
	#move_and_slide()
#
#func take_damage(damage: int, insta_death_chance: float, chaining_chance: float, 
				#knockBackPosition: Vector2, KnockBackForce, KnockBackTimer, drop_extra_xp_chance: float):
	#if dead:
		#return 
		#
	#if health < 0:
		#dead = true
		#return
	#if state != EnemyState.ATTACKING:
		#state = EnemyState.TAKING_DAMAGE
	#
#
	#
	#if KnockBackForce > 0:
		#knockBackDirection = (global_position - knockBackPosition).normalized()
		#knockBackForce = KnockBackForce / 4
		#knockBackTimer = KnockBackTimer / 4
		#
	#health -= damage
	#if pool_manager.has_method("spawn_label"):
		#var take_damage_label = pool_manager.spawn_label(self)
		#take_damage_label.position.y = position.y - 25
		#take_damage_label.show_damage(damage)
	#targeted = false
	#animation_player.play("HitFlash")
	#if state != EnemyState.ATTACKING:
		#state = EnemyState.CHASING
#
	#if health <= 0:
		#burned = false
		#state = EnemyState.DEAD
		#fire_animation.hide()
		#fire_animation_2.hide()
		#dead = true
		#velocity = Vector2.ZERO
		#animated_sprite_2d.stop()
		#animated_sprite_2d.play("Die")  # Play "Die" animation after hit
		#await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
		##animated_sprite_2d.play("Stay_Dead")
		#animation_player.play("FadeOut")  # Play fade out animation
		#await animation_player.animation_finished  # Wait for fade-out animation to finish
		#if truly_dead == true:
			#var cage = get_tree().get_first_node_in_group("Cage")
			#cage.clear_cage()
			#cage.spawner.start_timers()
			#for child in get_children():
				#if child is Label and child.has_method("return_to_pool"):
					#child.return_to_pool()
			#root_node.final_boss_defeated = true
			#root_node.canvas_layer.show_win_ui()
			#queue_free()
		#else:
			#health = 25000
			#dead = false
			#targeted = false
			#animation_player.play_backwards("FadeOut")
			#await animation_player.animation_finished
			#speed += 20
			#self.scale = Vector2(1.5, 1.5)
			#animated_sprite_2d.play("Idle")
			#state = EnemyState.IDLE
			#truly_dead = true
		#
	#
#func take_fire_damage(fire_damage: int, ticks: int):
	#if health < 0:
		#return
	#var fireTicksCopy = currentFireTicks
	#currentFireTicks += ticks
	#currentFireDamage = max(currentFireDamage, fire_damage)
	#burned = true
	#if (state != EnemyState.DEAD):
		#fire_animation.show()
		#fire_animation_2.show()
	#for i in range(ticks + fireTicksCopy):
		#if burned == true:
			#currentFireTicks -= 1
			#health -= fire_damage
			#if pool_manager.has_method("spawn_label"):
				#var take_fire_damage_label = pool_manager.spawn_label(self)
				#take_fire_damage_label.position.y = position.y -25
				#take_fire_damage_label.show_fire_damage(fire_damage)
			#animated_sprite_2d.self_modulate = Color("#ff8274")
			#fire_ticks_timer.start(0.2)
			#await fire_ticks_timer.timeout
			#animated_sprite_2d.self_modulate = Color("#ffffff")
			#fire_ticks_timer.start(0.8)
			#await fire_ticks_timer.timeout
#
		#
		#
		#if health <= 0 and state != EnemyState.DEAD:
			#state = EnemyState.DEAD
			#dead = true
			#targeted = false
			#burned = false
			#state = EnemyState.DEAD
			#fire_animation.hide()
			#fire_animation_2.hide()
			#velocity = Vector2.ZERO
			#animated_sprite_2d.stop()
			#if animated_sprite_2d.animation != "Die":
				#animated_sprite_2d.play("Die")  # Play "Die" animation after hit
			#await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
			#animation_player.play("FadeOut")  # Play fade out animation
			#await animation_player.animation_finished
		#if truly_dead == true:
			#var cage = get_tree().get_first_node_in_group("Cage")
			#cage.clear_cage()
			#cage.spawner.start_timers()
			#for child in get_children():
				#if child is Label and child.has_method("return_to_pool"):
					#child.return_to_pool()
			#root_node.final_boss_defeated = true
			#root_node.canvas_layer.show_win_ui()
			#queue_free()
		#else:
			#health = 25000
			#dead = false
			#targeted = false
			#animation_player.play_backwards("FadeOut")
			#await animation_player.animation_finished
			#speed += 20
			#self.scale = Vector2(1.5, 1.5)
			#animated_sprite_2d.play("Idle")
			#state = EnemyState.IDLE
			#truly_dead = true
	#
	#currentFireDamage = 0
	#currentFireTicks = 0
#
#
#
#func attack():
	#state = EnemyState.ATTACKING
	#velocity = Vector2.ZERO
	#animated_sprite_2d.play("Attack2")
	#await get_tree().create_timer(0.4).timeout
	#if (player.global_position - self.global_position).length() <= hit_distace:
		#player.take_damage(1, self.global_position, 200, 0.5)
	#await animated_sprite_2d.animation_finished
	##if NumberAttacks < 2:
		##NumberAttacks += 1
		##animated_sprite_2d.play("StabAttack")
		##await get_tree().create_timer(0.7).timeout
		##stab_collision_area.disabled = false
		##await animated_sprite_2d.animation_finished
		##stab_collision_area.disabled = true
	##else:
		##NumberAttacks = 0
		##animated_sprite_2d.play("SideWayThorns")
		##await get_tree().create_timer(0.5).timeout
		##thorns_collision_area.disabled = false
		##await animated_sprite_2d.animation_finished
		##thorns_collision_area.disabled = true
		##
	#await get_tree().create_timer(0.5).timeout
	#attacking = false
	#state = EnemyState.CHASING
	#
#func spawn_spirit():
	#state = EnemyState.SPAWN_SPIRIT
	#velocity = Vector2.ZERO
	#animated_sprite_2d.play("SummonSpirit")
	#await animated_sprite_2d.animation_finished
	#var spirit = SPIRIT_SUMMON.instantiate()
	#root_node.add_child(spirit)
	#spirit.global_position = marker_2d.global_position
	#state = EnemyState.CHASING
#
#func set_grabbed():
	#take_damage(100, 0, 0, self.global_position, 0, 0, 0)
#
#
#func _on_spawn_spirit_timer_timeout() -> void:
	#if state != EnemyState.ATTACKING and state != EnemyState.DEAD:
		#spawn_spirit()


extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var fire_animation_2: AnimatedSprite2D = $FireAnimation2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_ticks_timer: Timer = $FireTicksTimer
@onready var label: Label = $Label
@onready var marker_2d: Marker2D = $Marker2D

const SPIRIT_SUMMON = preload("res://Enemies/spirit_summon.tscn")

var speed = 100
var player: CharacterBody2D
var direction
var state
var targeted: bool = false
var dead: bool = false
var knockBackDirection: Vector2 = Vector2.ZERO
var knockBackForce: float = 0.0
var knockBackTimer: float = 0.0
var root_node
var health = 15000
var pool_manager
var burned = false
var hit_distace = 70
var attackKnockBackForce = 100
var attackKnockBackTimer = 0.5
var attacking: bool = false
var flame_targeted: bool = false
var currentFireTicks: int = 0
var currentFireDamage: int = 0
var handTargeted: bool = false
var phase_2_started: bool = false

enum EnemyState {IDLE, CHASING, ATTACKING, DEAD, TAKING_DAMAGE, SPAWNING, SPAWN_SPIRIT}

func _ready() -> void:
	await get_tree().process_frame
	state = EnemyState.SPAWNING
	root_node = get_tree().current_scene
	player = get_tree().get_first_node_in_group("Player")
	pool_manager = get_tree().get_first_node_in_group("Spawner")
	await animated_sprite_2d.animation_finished
	state = EnemyState.IDLE

func _physics_process(delta: float) -> void:
	label.text = str(health)

	match state:
		EnemyState.IDLE:
			if is_instance_valid(player) and player.health > 0:
				state = EnemyState.CHASING
		EnemyState.CHASING:
			animated_sprite_2d.play("Idle2")
			if is_instance_valid(player) and player.health > 0:
				direction = (player.global_position - global_position)
				if abs(direction.x) <= hit_distace and abs(direction.y) <= 20:
					state = EnemyState.ATTACKING
				else:
					velocity = direction.normalized() * speed
			else:
				state = EnemyState.IDLE
		EnemyState.ATTACKING:
			if not attacking:
				attacking = true
				attack()
		EnemyState.TAKING_DAMAGE:
			pass

	if state != EnemyState.DEAD and knockBackTimer > 0.0:
		velocity = knockBackForce * knockBackDirection
		knockBackTimer -= delta
		if knockBackTimer <= 0.0:
			velocity = Vector2.ZERO

	if is_instance_valid(player):
		var flip = player.global_position.x < global_position.x
		animated_sprite_2d.flip_h = flip
		fire_animation.flip_h = flip
		fire_animation_2.flip_h = flip
		if flip:
			fire_animation.position.x = 9
			fire_animation_2.position.x = -3
			marker_2d.position.x = -30
		else:
			fire_animation.position.x = -9
			fire_animation_2.position.x = 3
			marker_2d.position.x = 30

	else:
		player = get_tree().get_first_node_in_group("Player")

	move_and_slide()

func take_damage(damage: int, insta_death_chance: float, chaining_chance: float, knockBackPosition: Vector2, KnockBackForce, KnockBackTimer, drop_extra_xp_chance: float):
	if dead:
		return
	#if health <= 0:
		#await start_death_sequence()
		#return

	if KnockBackForce > 0:
		knockBackDirection = (global_position - knockBackPosition).normalized()
		knockBackForce = KnockBackForce / 10
		knockBackTimer = KnockBackTimer / 10

	health -= damage
	animation_player.play("HitFlash")
	targeted = false

	if pool_manager.has_method("spawn_label"):
		var label = pool_manager.spawn_label(self)
		label.position.y = position.y - 25
		label.show_damage(damage)

	if health <= 0:
		await start_death_sequence()
		
	if state != EnemyState.ATTACKING:
		state = EnemyState.CHASING

func take_fire_damage(fire_damage: int, ticks: int):
	if health <= 0:
		await start_death_sequence()
		return
	currentFireTicks += ticks
	currentFireDamage = max(currentFireDamage, fire_damage)
	burned = true
	fire_animation.show()
	fire_animation_2.show()

	for i in range(ticks):
		if not burned:
			break
		currentFireTicks -= 1
		health -= fire_damage
		if pool_manager.has_method("spawn_label"):
			var label = pool_manager.spawn_label(self)
			label.position.y = position.y - 25
			label.show_fire_damage(fire_damage)
		animated_sprite_2d.self_modulate = Color("#ff8274")
		fire_ticks_timer.start(0.2)
		await fire_ticks_timer.timeout
		animated_sprite_2d.self_modulate = Color("#ffffff")
		fire_ticks_timer.start(0.8)
		await fire_ticks_timer.timeout

		if health <= 0 and not dead:
			await start_death_sequence()

	currentFireDamage = 0
	currentFireTicks = 0
	burned = false
	dead = false
	fire_animation.hide()
	fire_animation_2.hide()

func start_death_sequence() -> void:
	state = EnemyState.DEAD
	dead = true
	burned = false
	fire_animation.hide()
	fire_animation_2.hide()
	velocity = Vector2.ZERO
	animated_sprite_2d.stop()
	if animated_sprite_2d.animation != "Die":
		animated_sprite_2d.play("Die")
	await animated_sprite_2d.animation_finished
	animation_player.play("FadeOut")
	await animation_player.animation_finished

	if phase_2_started:
		final_cleanup()
	else:
		start_phase_2()

func start_phase_2():
	print("startign phase 2")
	animation_player.play_backwards("FadeOut")
	await animation_player.animation_finished
	modulate.a = 1
	health = 25000
	dead = false
	targeted = false
	phase_2_started = true
	await animation_player.animation_finished
	speed += 30
	scale = Vector2(1.5, 1.5)
	animated_sprite_2d.play("Idle")
	state = EnemyState.IDLE

func final_cleanup():
	print("kill boss2")
	var cage = get_tree().get_first_node_in_group("Cage")
	cage.clear_cage()
	cage.spawner.start_timers()
	for child in get_children():
		if child is Label and child.has_method("return_to_pool"):
			child.return_to_pool()
	root_node.final_boss_defeated = true
	root_node.ui_canvas_layer.show_win_ui()
	queue_free()

func attack():
	state = EnemyState.ATTACKING
	velocity = Vector2.ZERO
	animated_sprite_2d.play("Attack2")
	await get_tree().create_timer(0.4).timeout
	if (player.global_position - global_position).length() <= hit_distace:
		player.take_damage(1, global_position, 200, 0.5)
	await animated_sprite_2d.animation_finished
	await get_tree().create_timer(0.5).timeout
	attacking = false
	state = EnemyState.CHASING

func spawn_spirit():
	state = EnemyState.SPAWN_SPIRIT
	velocity = Vector2.ZERO
	animated_sprite_2d.play("SummonSpirit")
	await animated_sprite_2d.animation_finished
	var spirit = SPIRIT_SUMMON.instantiate()
	root_node.add_child(spirit)
	spirit.global_position = marker_2d.global_position
	state = EnemyState.CHASING

func set_grabbed():
	take_damage(100, 0, 0, global_position, 0, 0, 0)

func _on_spawn_spirit_timer_timeout() -> void:
	if state != EnemyState.ATTACKING and state != EnemyState.DEAD:
		spawn_spirit()


func _on_player_collision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1, self.global_position, attackKnockBackForce, attackKnockBackTimer)
