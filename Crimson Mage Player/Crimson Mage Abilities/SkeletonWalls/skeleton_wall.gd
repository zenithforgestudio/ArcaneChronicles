extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var direction
var root
var knockBackForce: int = 100
var knockBackTimer: float = 0.2
var pool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	pool = get_tree().get_first_node_in_group("Spawner")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move_wall(direction: Vector2):
	var tween = get_tree().create_tween()
	var target_pos = self.global_position + direction.normalized() * 200
	tween.tween_property(self, "global_position", target_pos, 1.2)\
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_IN)


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(root.wall_damage + root.bonus_skull_damage, 0, 
					0, self.global_position, knockBackForce, knockBackTimer, 0)
					
					
					
func set_active(is_active):
	if is_active:
		show()
		#set_deferred("area_2d.collision_mask", 2)
		set_process(true)
		move_wall(Vector2(0, 1))
		await get_tree().create_timer(0.6).timeout
		set_deferred("area_2d.collision_mask", 0)
		animation_player.play("FadeOut")
		await animation_player.animation_finished
		if root.skeleton_walls_spawn_grave == true:
			pool.spawn_tombstone(self.global_position + Vector2(0, 50), false)
		queue_free()
		#set_active(false)
		#pool.add_skeleton_wall_to_pool(self)
	#else:
		#hide()
		#set_deferred("area_2d.collision_mask", 0)
		#set_process(false)
