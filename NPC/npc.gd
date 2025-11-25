extends Area2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var demon_npc: AnimatedSprite2D = $DemonNPC
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var panel
var interacted: bool = false
var heal : int = 1
var globalMusicPlayer
var upgrade_menu
var interacted_with_player: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalMusicPlayer = get_tree().get_first_node_in_group("musicPlayer")
	upgrade_menu = get_tree().get_first_node_in_group("UpgradeMenu")



	#player entered
func _on_body_entered(body: Node2D) -> void:
	if interacted_with_player == false:
		interacted_with_player = true
		print("player entered!")
		get_tree().paused = true
		globalMusicPlayer.stream_paused = true
		audio_stream_player_2d.play()
		upgrade_menu.show()
		upgrade_menu.show_demon_upgrades()
		await audio_stream_player_2d.finished
		globalMusicPlayer.stream_paused = false
		
		audio_stream_player_2d.play()
		globalMusicPlayer.stream_paused = true
		await audio_stream_player_2d.finished
		globalMusicPlayer.stream_paused = false
