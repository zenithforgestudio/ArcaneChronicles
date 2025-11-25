extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_projectile_timer: Timer = $ShootProjectileTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var root
var pool

var projectile = preload("res://Crimson Mage Player/Crimson Mage Abilities/Volcanoes/volcano_projectile.tscn")
var rock_pool: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	pool = get_tree().get_first_node_in_group("Spawner")
	await get_tree().create_timer(0.2).timeout
	shoot_projectiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot_projectiles():
	for i in range(0, root.volcano_projectiles):
		animated_sprite_2d.play("Shoot")
		await animated_sprite_2d.animation_finished
		pool.spawn_rock(marker_2d.global_position)
	await get_tree().create_timer(2).timeout
	
	if root.volcano_shoots_twice == true:
		for i in range(0, root.volcano_projectiles):
			animated_sprite_2d.play("Shoot")
			await animated_sprite_2d.animation_finished
			pool.spawn_rock(marker_2d.global_position)
			
	await get_tree().create_timer(2).timeout
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	queue_free()

		
#func get_rock():
	#if rock_pool.size() > 0:
		#var rock = rock_pool.pop_back()
		#rock.get_parent().remove_child(rock)
		#rock.show()
		#return rock
	#else:
		#var rock = preload("res://Crimson Mage Player/Crimson Mage Abilities/Volcanoes/volcano_projectile.tscn").instantiate()
		#return rock
		#
#func add_rock_to_pool(rock):
	##rock.hide()
	#rock_pool.append(rock)
	#
#func spawn_rock():
	#var rock = get_rock()
	#rock.global_position = marker_2d.global_position
	#root.add_child(rock)
	#rock.launch()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(50, 0, 0, self.global_position, 70, 0.2, 0)
	set_deferred("collision_shape_2d.disabled", true)
