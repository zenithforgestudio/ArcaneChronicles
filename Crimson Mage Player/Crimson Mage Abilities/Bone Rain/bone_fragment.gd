extends Area2D

@export var speed: float = 150

var root 
var stopMoving: bool = false
var tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	await get_tree().create_timer(5).timeout
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopMoving == false:
		position.y += speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		#print("Enemy Damaged!")
		root = get_tree().current_scene
		body.take_damage(root.rain_damage + root.bonus_damage / 5, 0, 0,
						self.global_position, 0, 0, 0)
		#queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	return_to_bone_pool()
	
	
func return_to_bone_pool() -> void:
	pass

func set_active(state: bool) -> void:
	pass
