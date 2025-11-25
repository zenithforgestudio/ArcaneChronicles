extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var marker_2d: Marker2D = $Area2D/CollisionShape2D/Marker2D


var player
var pool
var root
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	pool = get_tree().get_first_node_in_group("Spawner")
	root = get_tree().current_scene
	raise_from_the_ground()
	#set_active(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.


func raise_from_the_ground():
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	if player.global_position.x < global_position.x:
		animated_sprite_2d.flip_h = true
		collision_shape_2d.position.x = -16.5
	else:
		animated_sprite_2d.flip_h = false
		collision_shape_2d.position.x = 16.5
		
	animated_sprite_2d.play("Raise")
	await animated_sprite_2d.animation_finished
	await get_tree().create_timer(1).timeout
	if area_2d.has_overlapping_bodies():
		var bodies = area_2d.get_overlapping_bodies()
		var closest_enemy = null
		for body in bodies:
			var distance = INF
			if abs(marker_2d.global_position - body.global_position).length() < distance and not body.is_in_group("Boss"):
				distance = abs(marker_2d.global_position - body.global_position).length()
				closest_enemy = body
		if closest_enemy:
			closest_enemy.global_position = marker_2d.global_position
			closest_enemy.set_grabbed()
		animated_sprite_2d.play("Return")
		await animated_sprite_2d.animation_finished
		if root.skeleton_hands_spawn_skeleton == true:
			pool.spawn_skeleton(self.global_position + Vector2(0, 100))
	else:
		animated_sprite_2d.play("RaiseReversed")
		await animated_sprite_2d.animation_finished
		animation_player.play("FadeOut")
		await animation_player.animation_finished

			
	queue_free()
