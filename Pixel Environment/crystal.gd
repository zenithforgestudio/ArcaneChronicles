extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player
var interracted: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play_backwards("FadeOut")
	await animation_player.animation_finished
	animation_player.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if interracted == false:
			set_deferred("collision_shape_2d.disabled", true)
			interracted = true
			player = body
			player.get_crystal()
			animation_player.play("FadeOut")
			queue_free()
