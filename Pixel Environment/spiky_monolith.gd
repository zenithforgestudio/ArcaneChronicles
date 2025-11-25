extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var pool_manager
var root

func _ready() -> void:
	await get_tree().process_frame
	pool_manager = get_tree().get_first_node_in_group("pool")
	#animated_sprite_2d.flip_h = pick_random[true, false]
	animated_sprite_2d.flip_h = [true, false].pick_random()
	root = get_tree().current_scene

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(1, self.global_position, 200, 0.5)

func take_damage(damage, damage1, damage2, pos, damage3, damage4, damage5):
	var bullet = pool_manager.get_bullet()
	if bullet:
		root.add_child(bullet)  # Re-add bullet to the world
		bullet.global_position = pos  # Set spawn position
		bullet.set_active(true)  # Reactivate bullet if necessary
	await get_tree().create_timer(0.2).timeout
	
func take_fire_damge(damage, damage1):
	return
	
func destroy_timer(time: float):
	timer.start(time)

func disable_collision():
	set_deferred("collision_shape_2d.disabled", true)
	

func _on_timer_timeout() -> void:
	animation_player.play("FadeOut")
