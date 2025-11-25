extends CanvasLayer

#@onready var player: CharacterBody2D = $"../CrimsonMage"
#@onready var label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/Label
#@onready var skull_icon: TextureRect = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/TextureRect
#@onready var kill_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/Label
@onready var skull_icon: TextureRect = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/Control/TextureRect
@onready var skull_animation_player: AnimationPlayer = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/SkullAnimationPlayer
@onready var kill_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/KillCountBox/Control2/Label
@onready var text_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/TextLabel
@onready var health_bar: HBoxContainer = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HealthBar

@onready var end_game_container: MarginContainer = $EndGameContainer
@onready var end_game_label: Label = $EndGameContainer/VBoxContainer/EndGameLabel
@onready var quit_button: TextureButton = $EndGameContainer/VBoxContainer/QuitButton
@onready var revive_button: TextureButton = $EndGameContainer/VBoxContainer/ReviveButton

@onready var animation_player: AnimationPlayer = $EndGameContainer/AnimationPlayer
@onready var joystick: Node2D = $Joystick

#@onready var pause_button: TextureButton = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/PauseButton
#@onready var pause_button_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/PauseButton/PauseButtonLabel


var root
var level: int = 1
var player: CharacterBody2D = null
var transition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(player):
		player.health_changed.connect(checkDeath)  # Connect the signal
	transition = get_tree().get_first_node_in_group("Transition")
	root = get_parent()
	quit_button.disabled = true
	revive_button.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func checkDeath(new_health: int):
	pass

		#animation_player.play_backwards("you_died_appear")

#func animate_skull():
	#var t = create_tween()
	#t.tween_property(skull_icon, "rotation_degrees", 15, 0.1).as_relative()
	#t.tween_property(skull_icon, "rotation_degrees", -30, 0.2).as_relative()
	#t.tween_property(skull_icon, "rotation_degrees", 15, 0.1).as_relative()

func update_kill_counter(killings: int):
	kill_label.text = str(killings)
	skull_animation_player.play("SkullRotation")
	var t = create_tween()
	t.tween_property(kill_label, "scale", Vector2(1.4, 1.4), 0.1)
	t.tween_property(kill_label, "scale", Vector2(1, 1), 0.1).set_delay(0.1)
	
func update_player_level_text(new_level: int):
	level = new_level
	text_label.text = "Level " + str(new_level)



func _on_quit_button_pressed() -> void:
	transition.start_transition2()

func _on_revive_button_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	root.show_pause_button()
	end_game_container.hide()
	root.player.show()
	root.player.animated_sprite_2d.play_backwards("Death")
	#animated_sprite_2d.speed_scale = 0.5
	#await root.player.animated_sprite_2d.animation_finished
	#animated_sprite_2d.speed_scale = 1
	#root.player.timer_stop.emit()
	root.player.timer_start.emit()
	var runes = get_tree().get_nodes_in_group("RuneOrbitPath")
	for rune in runes:
		rune.show()
	root.player.dead = false
	root.player.invincible = true
	root.player.invincibility_timer.start()
	root.player.speed = 150.0
	root.player.heal(5)
	root.player.rain_timer.start()
	#point_light_2d.enabled = true
	await root.player.animated_sprite_2d.animation_finished
	root.player.animated_sprite_2d.play("Attack_Skull")
	


func show_death_ui():
	end_game_label.text = "You Died!"
	end_game_container.show()
	animation_player.play("FadeInEndGameContainer")
	quit_button.disabled = false
	revive_button.disabled = false


func show_win_ui():
	if root.time_finished == true and root.final_boss_defeated == true:
		root.kill_entities()
		get_tree().paused = true
		root.player.animated_sprite_2d.process_mode = Node.PROCESS_MODE_ALWAYS
		root.player.animated_sprite_2d.play("Attack_Powerful")
		await root.player.animated_sprite_2d.animation_finished
		root.player.animated_sprite_2d.process_mode = Node.PROCESS_MODE_INHERIT
		end_game_label.text = "You Won!"
		end_game_container.show()
		animation_player.play("FadeInEndGameContainer")
		revive_button.hide()
		quit_button.disabled = false
	

func show_quit_without_title():
	end_game_label.text = ""
	end_game_container.show()
	
	animation_player.play("FadeInEndGameContainer")
	animation_player.seek(1.95)
	
