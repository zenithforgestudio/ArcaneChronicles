extends CharacterBody2D

@export var pool_manager: Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var dead = false
var health = 100

func take_damage(damage, pos, knockbackforce, knockbacktimer):
	pass

func shoot_skull():
	if dead == false:
		var bullet = pool_manager.get_bullet()
		if bullet:
			get_parent().add_child(bullet)  # Re-add bullet to the world
			bullet.global_position = global_position  # Set spawn position
			bullet.set_active(true)  # Reactivate bullet if necessary



func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "Attack_Skull" and animated_sprite_2d.frame == 12:
		shoot_skull()
