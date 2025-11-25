extends Area2D

var root
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(root.orbitting_orb_damage + root.bonus_damage / 4, 0, 0,
						self.global_position, root.orbitting_orb_knockback, 0.2, 0)
