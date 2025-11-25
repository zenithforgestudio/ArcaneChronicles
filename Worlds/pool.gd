extends Node2D  # Or a suitable base class


@export var bullet_scene: PackedScene
@export var XPdrop : PackedScene

var player: CharacterBody2D
const xp = preload("res://Items/xp_drop.tscn")
var bullet_pool: Array = []
var xp_pool: Array = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func get_bullet() -> Node2D:
	if bullet_pool.size() > 0:
		var bullet = bullet_pool.pop_back()
		bullet.get_parent().remove_child(bullet)  # Remove from pool
		bullet.show()
		return bullet
	else:
		# If no bullets in the pool, create a new one
		var bullet = preload("res://Crimson Mage Player/Skull Bullet/skull_bullet.tscn").instantiate()
		return bullet



func add_bullet_to_pool(bullet: Area2D) -> void:
	bullet.hide()
	bullet_pool.append(bullet)


func get_xp() -> Area2D:
	if xp_pool.size() > 0:
		var xp = xp_pool.pop_back()
		xp.get_parent().remove_child(xp)
		xp.show()
		return xp
	else:
		var xp = preload("res://Items/xp_drop.tscn").instantiate()
		return xp
		
func add_xp_to_pool(xp: Area2D) -> void:
	xp.hide()
	xp_pool.append(xp)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE:
		spawn_xp()
		
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_1 :
		damage_player()

func spawn_xp():
	var xp_orb = xp.instantiate()
	xp_orb.global_position = player.global_position + Vector2(0, -50)
	get_tree().current_scene.add_child(xp_orb)

func damage_player():
	player.take_damage(1, player.global_position, 0, 0)
	
