extends Area2D

@onready var left: Sprite2D = $Left
@onready var rigth: Sprite2D = $Rigth
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player
var pool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	pool = get_tree().get_first_node_in_group("Spawner")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(is_active: bool, facing_right: bool):
	if is_active:
		set_deferred("collision_shape_2d.disabled", false)
		animation_player.play("FadeIn")
		
		if facing_right == true:
			left.show()
			rigth.hide()
		else:
			left.hide()
			rigth.show()
			
			
	else:
		set_deferred("collision_shape_2d.disabled", true)
		animation_player.play("FadeOut")
		await animation_player.animation_finished
		pool.spawn_skeleton(self.global_position)
		return_to_pool()
	
			

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_active(false, true)
	#print("Spawn skeleton")

func return_to_pool():
	pool.add_tombstone_to_pool(self)
