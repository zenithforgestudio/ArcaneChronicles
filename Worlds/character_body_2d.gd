extends CharacterBody2D

signal health_changed(new_health)
signal timer_stop
signal timer_start
signal XP_gained(new_xp)
signal sprite_flipped

@export var max_health : int = 5
@export var pool_manager: Node2D
@export var speed = 60.0

@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var skull_bullet_marker: Marker2D = $AnimatedSprite2D/SkullBulletMarker
#@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var world_1: Node2D = $".."
@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var xp_sound: AudioStreamPlayer2D = $xpSound
@onready var familiar: Node2D = $Familiar1
@onready var bone_rain: Node2D = $BoneRain
@onready var rain_timer: Timer = $RainTimer
@onready var fire_ball_sound_streamer: AudioStreamPlayer2D = $FireBallSoundStreamer
@onready var fire_circle_timer: Timer = $FireCircleTimer
@onready var item_collect_collision_shape: CollisionShape2D = $CollectionAura/ItemCollectCollisionShape
@onready var familiar_2: Node2D = $Familiar2
@onready var audio_stream_player_2d_ominous_music: AudioStreamPlayer2D = $AudioStreamPlayer2D2


var skullBullet = preload("res://Crimson Mage Player/Skull Bullet/skull_bullet.tscn")
var fire_ring = preload("res://Crimson Mage Player/Crimson Mage Abilities/Fire Circle/fire_circle.tscn")


var level : int = 1
var upgrade_menu
var playerXP = 0
var invincible = false
var this_script  = "character_body_2D.gd"
var health
var dead : bool = false
var joystick
var globalMusicPlayer: AudioStreamPlayer
var root
var knockBackDirection 
var knockBackForce 
var knockBackTimer 
var closest_enemy: CharacterBody2D = null
var pool
var await_crystal = false
var upgradeMenu
var took_crystal: bool = false

func _ready() -> void:

	await get_tree().process_frame
	upgradeMenu = get_tree().get_first_node_in_group("UpgradeMenu")
	root = get_parent()
	health = max_health
	pool = get_tree().get_first_node_in_group("Spawner")
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")
	#call_deferred("shoot_skull")
	joystick = get_tree().get_first_node_in_group("joystick")
	await get_tree().create_timer(1.3).timeout
	#activate_familiar1()
	#fire_rate_timer.start()
	globalMusicPlayer = get_tree().get_first_node_in_group("musicPlayer")


func _physics_process(delta: float) -> void:
	
	##Movement handling
	var direction = Vector2.ZERO
	# Initialize movement direction vector
	if joystick != null:
		direction = joystick.posVector
	else:
		joystick = get_tree().get_first_node_in_group("JoyStick")
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	
	if horizontal_direction != null:
		skull_bullet_marker.position.x = abs(skull_bullet_marker.position.x) * (1 if animated_sprite_2d.flip_h else -1)


	if await_crystal == true:
		await_crystal = false
		await get_tree().create_timer(3).timeout
		audio_stream_player_2d_ominous_music.play()
		get_tree().paused = true
		globalMusicPlayer.stream_paused = true
		upgrade_menu.show()
		upgradeMenu.show_upgrades()
		await audio_stream_player_2d_ominous_music.finished
		globalMusicPlayer.stream_paused = false

	# Get input for all directions
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		
	# Normalize the direction vector to ensure consistent speed in diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * (speed + root.player_speed) 
	else:
		velocity = Vector2.ZERO

	# Flip the sprite horizontally based on movement direction if game not paused
	if velocity.x < 0:
		if Engine.time_scale > 0:
			animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		if Engine.time_scale > 0:
			animated_sprite_2d.flip_h = false

	if health > 0 and dead == false:
		if knockBackTimer and knockBackTimer > 0.0:
			velocity = knockBackForce * knockBackDirection
			knockBackTimer -= delta
			if knockBackTimer <= 0.0:
				velocity = Vector2.ZERO
	move_and_slide()
	
	
	#increas PlayerXP
func increasePlayerXP(XP):
	xp_sound.pitch_scale = randf_range(0.7, 1.3)
	playerXP += XP
	XP_gained.emit(playerXP)
	xp_sound.play()
	#await get_tree().create_timer(0.3).timeout
	#xp_sound.stop()
	

	#gather 
	
	#damage the player
func take_damage(damage, source_position: Vector2, KnockBackForce: float, KnockBackTimer: float):
	var save_chance = randf_range(0, 1)
	if save_chance <= root.player_dodge_chance and root.player_dodge_chance > 0.0:
		return
	if invincible == false:
		if health > 1:
			camera_2d.apply_shake()
		else:
			camera_2d.apply_GameOver_shake()
		if KnockBackForce > 0:
			knockBackDirection = (global_position - source_position).normalized()
			knockBackForce = KnockBackForce
			knockBackTimer = KnockBackTimer
		invincible = true
		set_deferred("collision_mask.2", false)
		invincibility_timer.start()
		animated_sprite_2d.play("Hit")  # Play the hit animation
		health -= damage
		#print(health)
		health_changed.emit(health)
		await animated_sprite_2d.animation_finished
		if health > 0:
			animated_sprite_2d.play("Attack_Skull")  # Change back to Attack_Skull animation
		else:
			root.hide_pause_button()
			point_light_2d.enabled = false
			timer_stop.emit()
			dead = true
			speed = 0
			animated_sprite_2d.play("Death")
			await animated_sprite_2d.animation_finished
			#animated_sprite_2d.hide()
			root.ui_canvas_layer.show_death_ui()

			hide()
			rain_timer.stop()
			var runes = get_tree().get_nodes_in_group("RuneOrbitPath")
			for rune in runes:
				rune.hide()
			# Slow motion effect on death
			var tween = get_tree().create_tween()
			tween.tween_property(Engine, "time_scale", 0.05, 1.0)  
			await tween.finished
			get_tree().paused = true
			Engine.time_scale = 1
	
	#heal the player
func heal(heal):
	health += heal
	#print(health)
	health_changed.emit(health)


func _on_invincibility_timer_timeout() -> void:
	invincible = false
	set_deferred("collision_mask.2", true)
	
	
func shoot_skull():
	if dead == false:
		fire_ball_sound_streamer.pitch_scale = randf_range(0.8, 1.2)
		fire_ball_sound_streamer.play(0.08)
		for skull in world_1.skullsNumber:
			var bullet = pool_manager.get_bullet()
			if bullet:
				get_parent().add_child(bullet)  # Re-add bullet to the world
				bullet.global_position = global_position  # Set spawn position
				bullet.set_active(true)  # Reactivate bullet if necessary
			await get_tree().create_timer(0.2).timeout



func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d == null:
		animated_sprite_2d = $AnimatedSprite2D
	if animated_sprite_2d.animation == "Attack_Skull" and animated_sprite_2d.frame == 10:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			if enemy.health > 0:
				enemy.targeted = false
	if animated_sprite_2d.animation == "Attack_Skull" and animated_sprite_2d.frame == 12:
		shoot_skull()

func levelUP():
	#audio_stream_player_2d.play(0.2)
	globalMusicPlayer.stream_paused = true
	#get_tree().paused = true
	animation_player.play("levelUP")
	await animation_player.animation_finished
	upgrade_menu.show()
	upgrade_menu.show_upgrades()
	#get_tree().paused = false
	await audio_stream_player_2d.finished
	
	globalMusicPlayer.stream_paused = false

func _on_rain_timer_timeout() -> void:
	if root.is_raining == true:
		print("rain")
		bone_rain.rain_bones(self.global_position)
	rain_timer.start(root.rain_timer)


func _on_fire_circle_timer_timeout() -> void:
	if root.fire_circle == true:
		var ring = fire_ring.instantiate()
		ring.global_position = global_position
		get_tree().current_scene.add_child(ring)
	fire_circle_timer.start(root.fire_circle_start_timer)


func _on_player_collection_radius_button_pressed() -> void:
	item_collect_collision_shape.shape.radius = 10000
	await get_tree().create_timer(60).timeout
	item_collect_collision_shape.shape.radius = root.player_collection_radius
	
func activate_familiar1():
	familiar.set_active(true)
	
func activate_familiar2():
	familiar_2.set_active(true)

func find_nearest_enemy() -> CharacterBody2D:
	var nearest_enemy: CharacterBody2D = null
	var distance = INF
	var bodies = get_tree().get_nodes_in_group("Enemy")
	for body in bodies:
		if body is CharacterBody2D:
			var current_distance = (body.global_position - self.global_position).length() 
			if current_distance < distance:
				nearest_enemy = body
				distance = current_distance
	return nearest_enemy


func _on_spawn_orbs_timer_timeout() -> void:
	if root.spawn_random_xp == true:
		add_xp(self.global_position + Vector2((randi_range(-100, 100)), (randi_range(-100, 100))))


func add_xp(pos):
	if pool_manager != null:
		var xp = pool_manager.get_xp()
		if xp != null:
			get_parent().add_child(xp)  # Re-add xp to the world
			xp.global_position = pos  # Set spawn position
			xp.set_active(true)  # Reactivate xp if necessary


func _on_spawn_fire_pillar_timeout() -> void:
	if root.spawn_fire_pillar:
		pool.spawn_pillar(self.global_position)


func _on_spawn_tombstone_timer_timeout() -> void:
	if root.player_spawn_tombstone == true:
		var posx = self.global_position.x + randi_range(-200, 200)
		var posy = self.global_position.y + randi_range(-200, 200)
		if posx > self.global_position.x:
			pool.spawn_tombstone(Vector2(posx, posy), false)
		else:
			pool.spawn_tombstone(Vector2(posx, posy), true)
			
		


func _on_wizard_heal_timer_timeout() -> void:
	if root.wizard_heal == true:
		heal(1)
		
func get_crystal():
	if took_crystal == false:
		took_crystal = true
		heal(1)
		audio_stream_player_2d_ominous_music.play()
		get_tree().paused = true
		globalMusicPlayer.stream_paused = true
		upgrade_menu.show()
		upgradeMenu.show_demon_upgrades()
		await audio_stream_player_2d_ominous_music.finished
		globalMusicPlayer.stream_paused = false
		await_crystal = true
	
	

	
