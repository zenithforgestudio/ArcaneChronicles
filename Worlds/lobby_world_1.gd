extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var lobby_ui: CanvasLayer = $LobbyUI


var skull_damage = 100
var bonus_damage = 0
var skull_kill_chance: float = 0.0
var chaining_chance: float = 0.0
var bodies
var chaining_damage = false
var chain_extra_xp = false
var bullet_fire_damage = false
var drop_extra_xp_chance: float = 0.0
var drop_health_orb_chance: float = 0.0
var drop_health_orb: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lobby_ui.transition.finish_transition()
	lobby_ui.label.show()
	#button = get_tree().current_scene.get_node(MarginContainer/VBoxContainer/Button)
	#button.grab_focus()
	await get_tree().process_frame
	increase_db()
	audio_stream_player.seek(randf_range(0, 120))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#bodies = get_tree().get_nodes_in_group("Enemy")
	#for body in bodies:
		#if body.has_meta("take_damage_label"):
			#body.take_damage_label.hide()


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#button.emit_signal("pressed")



func _on_clear_x_pdrops_timeout() -> void:
	for xp in get_tree().get_nodes_in_group("XP"):
		xp.return_to_pool()  # Example: print the name of each XP node


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.seek(randf_range(0, 120))
	audio_stream_player.play()
	
func increase_db():
	audio_stream_player.volume_db = -30
	var tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -15, 2.0)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
