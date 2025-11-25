extends Node2D

@export var swordman: PackedScene
@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var swordman_spawn_timer: Timer = $SwordmanSpawnTimer

var swordman_pool: Array = []

func _ready():
	# Set up a timer to spawn enemies periodically
	pass

func spawn_swordman():
	# Instantiate an enemy from the PackedScene and position it at the path start
	var enemy = get_swordman()
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = path_follow_2d.global_position
	
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	
func get_swordman() -> Node2D:
	if swordman_pool.size() > 0:
		var swordman = swordman_pool.pop_back()
		swordman.get_parent().remove_child(swordman)  # Remove from pool
		swordman.show()
		return swordman
	else:
		# If no swordmans in the pool, create a new one
		var swordman = preload("res://Enemies/swordman pack/melee_swordman.tscn").instantiate()
		return swordman



func add_swordman_to_pool(swordman: CharacterBody2D) -> void:
	swordman.hide()
	swordman_pool.append(swordman)


func _on_swordman_spawn_timer_timeout() -> void:
	spawn_swordman()
