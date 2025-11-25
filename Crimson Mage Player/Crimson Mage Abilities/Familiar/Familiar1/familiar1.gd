extends Node2D

@onready var familiar_animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_skeleton_xp_timer: Timer = $SpawnSkeletonXPTimer

var player
var pool
var root
var xp_pool_manager
var activated = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_parent()
	pool = get_tree().get_first_node_in_group("Spawner")
	root = get_tree().current_scene
	xp_pool_manager = get_tree().get_first_node_in_group("pool")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		if player.animated_sprite_2d.flip_h == true:
			familiar_animated_sprite_2d.flip_h = true
		else:
			familiar_animated_sprite_2d.flip_h = false
			
		position.x = abs(position.x) * (1 if player.animated_sprite_2d.flip_h else -1)

func set_active(is_active: bool):
	if is_active:
		activated = true
		show()


func _on_spawn_skeleton_xp_timer_timeout() -> void:
	if activated:
		if root.familiar1_kill_enemy == true:
			#print("kill enemy")
			kill_closest_enemy()
			
		if root.familiar1_spawn_xp == true:
			add_xp()
	spawn_skeleton_xp_timer.start(root.familiar1_spawn_timer)
	
func get_closest_enemy() -> CharacterBody2D:
	var distance = INF
	var closest_enemy = null
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if (enemy.global_position - self.global_position).length() < distance and enemy.targeted == false and enemy.health > 0 and not enemy.is_in_group("Boss"):
			distance = (enemy.global_position - self.global_position).length()
			closest_enemy = enemy
	return closest_enemy
	
func kill_closest_enemy():
	var enemy = get_closest_enemy()
	if enemy:
		enemy.take_damage(enemy.health, 0, 0, self.global_position, 0, 0, 0)
		
func add_xp():
	if xp_pool_manager != null:
		var xp = xp_pool_manager.get_xp()
		if xp != null:
			root.add_child(xp)  # Re-add xp to the world
			if familiar_animated_sprite_2d.flip_h == false:
				xp.global_position = player.global_position + Vector2(200, 0)
			else:
				xp.global_position = player.global_position + Vector2(-200, 0)
			xp.set_active(true)  # Reactivate xp if necessary
