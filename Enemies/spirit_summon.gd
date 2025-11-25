extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var fire_ticks_timer: Timer = $FireTicksTimer


var player
var health = 150
var targeted: bool = false
var dead: bool = false
var burned: bool = false
var knockBackDirection
var knockBackForce
var knockBackTimer
var flame_targeted
var currentFireTicks: int = 0
var currentFireDamage: int = 0
var pool_manager
var root_node
var chained

const SPEED = 80.0


func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	pool_manager = get_tree().get_first_node_in_group("Spawner")
	root_node = get_tree().current_scene
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_instance_valid(player):
		position = position.move_toward(player.global_position, SPEED * delta)
		
	if knockBackTimer and knockBackTimer > 0.0:
		velocity = knockBackForce * knockBackDirection
		knockBackTimer -= delta
		if knockBackTimer <= 0.0:
			velocity = Vector2.ZERO
	if is_instance_valid(player):
		animated_sprite_2d.look_at(player.global_position)
		animated_sprite_2d.rotation -= PI / 2
	else:
		player = get_tree().get_first_node_in_group("Player")
	

	move_and_slide()

func take_damage(damage: int, insta_death_chance: float, chaining_chance: float, 
				knockBackPosition: Vector2, KnockBackForce, KnockBackTimer, drop_extra_xp_chance: float):
	if dead or health <= 0:
		return 
		
	animation_player.play("HitFlash")
		
	if KnockBackForce > 0:
		knockBackDirection = (global_position - knockBackPosition).normalized()
		knockBackForce = KnockBackForce 
		knockBackTimer = KnockBackTimer
		
	var rng = randf_range(0, 1)
	if rng < root_node.skull_kill_chance:
		health = 0
	else:
		if root_node.chaining_damage:
			health -= 1.25 * damage
		else:
			health -= damage
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
		dead = true
		targeted = false
		set_deferred("collision_shape_2d.disabled", true)
		animated_sprite_2d.play("Death")
		await animated_sprite_2d.animation_finished
		queue_free()
		
	
func take_fire_damage(fire_damage: int, ticks: int):
	if dead or health < 0:
		return
	flame_targeted = false
	var fireTicksCopy = currentFireTicks
	currentFireTicks += ticks
	currentFireDamage = max(currentFireDamage, fire_damage)
	burned = true
	fire_animation.show()
	for i in range(ticks + fireTicksCopy):
		if burned == true:
			currentFireTicks -= 1
			health -= max(fire_damage, currentFireDamage)
			if pool_manager.has_method("spawn_label"):
				var take_fire_damage_label = pool_manager.spawn_label(self)
				take_fire_damage_label.position.y = position.y -25
				take_fire_damage_label.show_fire_damage(fire_damage)
		if health <= 0:
			dead = true
			fire_animation.hide()
			if animated_sprite_2d.animation != "Death":
				dead = true
				velocity = Vector2.ZERO
				animated_sprite_2d.stop()
				animated_sprite_2d.play("Death")  # Play "Die" animation after hit
				await animated_sprite_2d.animation_finished  # Wait for the "Die" animation to finish
				animation_player.play("FadeOut")  # Play fade out animation
				targeted = false
				await animation_player.animation_finished  # Wait for fade-out animation to finish
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



func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(1, self.global_position, 50, 0.2)
	queue_free()
