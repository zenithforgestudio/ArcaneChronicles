extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var root

func start_transition():
	layer = 1
	show()
	animation_player.play("Transition")
	await animation_player.animation_finished
	await get_tree().process_frame
	get_tree().paused = true
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Worlds/world_1.tscn")
	#await get_tree().process_frame
	#await get_tree().create_timer(0.2).timeout
	#get_tree().paused = false
	
func start_transition2():
	layer = 1
	show()
	animation_player.play("Transition")
	await animation_player.animation_finished
	await get_tree().process_frame
	get_tree().paused = true
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Worlds/lobby_world_1.tscn")

	
func finish_transition():
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	get_tree().paused = false
	layer = -50
	hide()
	#queue_free()
	
func transition_to_scene(scene: String):
	layer = 1
	show()
	animation_player.play("Transition")
	await animation_player.animation_finished
	await get_tree().process_frame
	get_tree().paused = true
	await get_tree().process_frame
	get_tree().change_scene_to_file(scene)
