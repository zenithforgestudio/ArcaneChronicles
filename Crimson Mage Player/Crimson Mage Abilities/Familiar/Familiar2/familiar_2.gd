extends Node2D

@onready var familiar_2_animated_sprite: AnimatedSprite2D = $Familiar2AnimatedSprite
@onready var spawn_skeleton_tombstone_timer: Timer = $SpawnSkeletonTombstoneTimer

var player
var pool
var activated: bool = false
var root
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_parent()
	root = get_tree().current_scene
	pool = get_tree().get_first_node_in_group("Spawner")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		if player.animated_sprite_2d.flip_h == true:
			familiar_2_animated_sprite.flip_h = false
		else:
			familiar_2_animated_sprite.flip_h = true
		position.x = abs(position.x) * (-1 if player.animated_sprite_2d.flip_h else 1)


func set_active(is_active: bool):
	if is_active:
		activated = true
		show()


func _on_spawn_skeleton_tombstone_timer_timeout() -> void:
	if activated:
		if root.familiar2_spawn_skeleton == true:
			if familiar_2_animated_sprite.flip_h == true:
				pool.spawn_skeleton(self.global_position + Vector2(100, randi_range(-100, 100)))
			else:
				pool.spawn_skeleton(self.global_position + Vector2(-100, randi_range(-100, 100)))
		if root.familiar2_spawn_tombstone == true:
			if familiar_2_animated_sprite.flip_h == true:
				pool.spawn_tombstone(self.global_position + Vector2(200, -100), false)
			else:
				pool.spawn_tombstone(self.global_position + Vector2(-200, -100), true)
				
	spawn_skeleton_tombstone_timer.start(root.familiar2_spawn_timer)

		
