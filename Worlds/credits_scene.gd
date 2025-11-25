extends Node2D

@onready var go_to_lobby_button: TextureButton = $CanvasLayer/GoToLobbyButton
@onready var transition: CanvasLayer = $CanvasLayer/Transition
@onready var margin_container: MarginContainer = $CanvasLayer/MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	transition.finish_transition()
	transition.hide()
	get_tree().paused = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_to_lobby_button_pressed() -> void:
	transition.show()
	go_to_lobby_button.disabled = true
	go_to_lobby_button.release_focus()
	margin_container.hide()
	transition.transition_to_scene("res://Worlds/lobby_world_1.tscn")

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()


func _on_link_bat_pressed() -> void:
	OS.shell_open("https://papoycore.itch.io/bat")


func _on_link_sound_1_pressed() -> void:
	OS.shell_open("https://freesound.org/people/univ_lyon3/sounds/485664/")


func _on_link_fire_circle_pressed() -> void:
	OS.shell_open("https://www.vecteezy.com/video/3572943-green-screen-ring-of-fire-with-black-background-sample")


func _on_link_eye_monster_pressed() -> void:
	OS.shell_open("https://lionheart963.itch.io/flying-eye-creature")


func _on_demon_pressed() -> void:
	OS.shell_open("https://papoycore.itch.io/fantazy-30")


func _on_fire_column_pressed() -> void:
	OS.shell_open("https://sanctumpixel.itch.io/fire-column-pixel-art-effect")


func _on_boss_1_pressed() -> void:
	OS.shell_open("https://old-man-0.itch.io/trans-dark")


func _on_boss_2_pressed() -> void:
	OS.shell_open("https://darkpixel-kronovi.itch.io/undead-executioner")


func _on_crystal_pressed() -> void:
	OS.shell_open("https://frakassets.itch.io/free-dark-crystal-shrine")


func _on_knight_pressed() -> void:
	OS.shell_open("https://sventhole.itch.io/hero-knight")


func _on_necromancer_pressed() -> void:
	OS.shell_open("https://creativekind.itch.io/necromancer-free")


func _on_archer_pressed() -> void:
	OS.shell_open("https://luizmelo.itch.io/huntress-2")


func _on_skeleton_pressed() -> void:
	OS.shell_open("https://sanctumpixel.itch.io/sword-skeleton-pixel-art-character")


func _on_swordman_pressed() -> void:
	OS.shell_open("https://sanctumpixel.itch.io/swordman-top-down-pixel-art-character-assets")


func _on_monolyth_pressed() -> void:
	OS.shell_open("https://lexlom.itch.io/black-monolith")


func _on_back_ground_pressed() -> void:
	OS.shell_open("https://szadiart.itch.io/rpg-worlds-ca")


func _on_mage_pressed() -> void:
	OS.shell_open("https://creativekind.itch.io/npc-mage-free")


func _on_font_pressed() -> void:
	OS.shell_open("https://ninjikin.itch.io/font-antiquity-script")
