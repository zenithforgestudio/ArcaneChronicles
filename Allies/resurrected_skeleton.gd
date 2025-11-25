extends CharacterBody2D

@export var speed: int = 50
@export var health: float = 0.0
@export var hit_distance: int
@export var damage: int = 100

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
@onready var shield_timer: Timer = $ShieldTimer

var closest_enemy: CharacterBody2D = null
var dead: bool = false
var player: CharacterBody2D = null
var direction: Vector2 = Vector2.ZERO
var tween
var raised = false
var attacking: bool = false
var can_attack: bool = true
var knockBackDirection: Vector2 = Vector2.ZERO
var knockBackForce: float = 0.0
var knockBackTimer: float = 0.0
var attackKnockBackForce: int = 50
var attackKnockBackTimer: float = 0.2
var invincible: bool = false
var root
var xp_pool_manager
var attack_cooldown = 0.5

enum skeletonState {IDLE, CHASING, ATTACKING, DEAD, TAKING_DAMAGE, RAISING, CORPSE}
var state: skeletonState = skeletonState.IDLE

func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	player = get_tree().get_first_node_in_group("Player")
	closest_enemy = get_closest_enemy()
	state = skeletonState.CORPSE
	damage = root.skeleton_damage
	health = root.skeleton_health
	xp_pool_manager = get_tree().get_first_node_in_group("pool")

	if is_instance_valid(player):
		animated_sprite_2d.flip_h = player.position.x < self.global_position.x

	animated_sprite_2d.play("Corpse1")
	show_skeleton()
	await get_tree().create_timer(1).timeout
	raise_dead()
	state = skeletonState.RAISING
	await get_tree().create_timer(1).timeout
	health = root.skeleton_health
	speed = root.skeleton_speed
	damage = root.skeleton_damage
	dead = false
	animated_sprite_2d.play("Idle")
	state = skeletonState.IDLE

func _physics_process(delta: float) -> void:
	if dead:
		return

	match state:
		skeletonState.IDLE:
			animated_sprite_2d.play("Idle")
			velocity = Vector2.ZERO
			if is_instance_valid(player) and is_instance_valid(closest_enemy):
				if player.health > 0 and health > 0 and closest_enemy.health > 0:
					state = skeletonState.CHASING

#
		skeletonState.CHASING:
			if closest_enemy == null or closest_enemy.health <= 0:
				state = skeletonState.IDLE
			else:
				direction = closest_enemy.global_position - global_position
				if direction.length() <= hit_distance:
					state = skeletonState.ATTACKING
				else:
					velocity = direction.normalized() * speed
					if direction != Vector2.ZERO and animated_sprite_2d.animation != "Walk":
						animated_sprite_2d.play("Walk")
#
		skeletonState.ATTACKING:
			velocity = Vector2.ZERO
			if attacking == false:
				attacking = true
				animated_sprite_2d.play("Attack2")
				await get_tree().create_timer(0.3).timeout
				if closest_enemy:
					closest_enemy.take_damage(damage + root.bonus_skull_damage, 0, 0, self.global_position, knockBackForce, knockBackTimer, 0)
				if closest_enemy.health <= 0:
					closest_enemy = null
				await animated_sprite_2d.animation_finished
				attacking = false
				if is_instance_valid(closest_enemy):
					if (closest_enemy.global_position - self.global_position).length() > hit_distance or closest_enemy.health <= 0 or not closest_enemy.is_visible_in_tree():
						state = skeletonState.IDLE
						closest_enemy = get_closest_enemy()
					else:
						state = skeletonState.ATTACKING
				
#
	# Flip sprite
	if closest_enemy:
		animated_sprite_2d.flip_h = closest_enemy.position.x < self.global_position.x

	# Knockback
	if state != skeletonState.DEAD:
		if knockBackTimer > 0.0:
			velocity = knockBackForce * knockBackDirection
			knockBackTimer -= delta
			if knockBackTimer <= 0.0:
				velocity = Vector2.ZERO

	move_and_slide()
#
func take_damage(damage, knockBackPosition: Vector2, KnockBackForce, KnockBackTimer):
	if dead or invincible:
		return
#
	if state != skeletonState.ATTACKING:
		state = skeletonState.TAKING_DAMAGE

#
		if KnockBackForce > 0:
			knockBackDirection = (global_position - knockBackPosition).normalized()
			knockBackForce = KnockBackForce / 2
			knockBackTimer = KnockBackTimer / 2
	invincible = true
	shield_timer.start()
	health -= damage
	animation_player.play("HitFlash")
#
	if health <= 0:
		state = skeletonState.DEAD
		dead = true
		velocity = Vector2.ZERO
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Die")
		collision_shape_2d.set_deferred("disabled", true)
		await animated_sprite_2d.animation_finished
		animation_player.play("FadeOut")
		await animation_player.animation_finished
		if root.skeleton_drop_xp_chance > 0.0:
			var rng = randf_range(0, 1)
			if rng < root.skeleton_drop_xp_chance:
				call_deferred("add_xp", self.global_position + Vector2(-20, 0))
		queue_free()
	
	if state != skeletonState.ATTACKING:
		state = skeletonState.IDLE

func get_closest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var found_enemy = null
	var found_distance = INF
	for enemy in enemies:
		if enemy is CharacterBody2D and enemy.health > 0:
			var dist = (enemy.global_position - global_position).length()
			if dist < found_distance:
				found_distance = dist
				found_enemy = enemy
	return found_enemy

#
func show_skeleton():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)

func hide_skeleton():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)

func raise_dead() -> void:
	animated_sprite_2d.play("Raise")
	await animated_sprite_2d.animation_finished
	raised = true

func add_xp(pos):
	if xp_pool_manager != null:
		var xp = xp_pool_manager.get_xp()
		if xp != null:
			get_parent().add_child(xp)
			xp.global_position = pos
			xp.set_active(true)

func _on_get_target_timer_timeout() -> void:
	closest_enemy = get_closest_enemy()

func _on_shield_timer_timeout() -> void:
	invincible = false

func _on_death_timer_timeout() -> void:
	take_damage(health, Vector2.ZERO, 0, 0)
