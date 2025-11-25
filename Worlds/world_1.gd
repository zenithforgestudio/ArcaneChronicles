extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui_canvas_layer: CanvasLayer = $UICanvasLayer
@onready var transition: CanvasLayer = $Transition
@onready var player_collection_radius_button: TextureButton = $UICanvasLayer/PlayerCollectionRadiusButton
@onready var book_close: Sprite2D = $UICanvasLayer/PauseButton/BookClose
@onready var book_open: Sprite2D = $UICanvasLayer/PauseButton/BookOpen
#@onready var icon_label: Label = $ScrollContainer/UpgradeIcons/IconLabel
@onready var scroll_container_parent: Control = $UICanvasLayer/ScrollContainerParent
@onready var upgrade_icons_animation_player: AnimationPlayer = $UICanvasLayer/ScrollContainerParent/UpgradeIconsAnimationPlayer
@onready var icon_buttons_label: Label = $UICanvasLayer/ScrollContainerParent/IconButtonsLabel
@onready var upgrade_icons_scroll_container: ScrollContainer = $UICanvasLayer/ScrollContainerParent/UpgradeIconsScrollContainer
@onready var pause_button: Button = $UICanvasLayer/PauseButton
@onready var quit_button: TextureButton = $UICanvasLayer/QuitButton

var JoyStick
var flame = preload("res://Crimson Mage Player/Crimson Mage Abilities/Homing Flame/homing_flame.tscn")

var player: CharacterBody2D = null

var basic_upgrades: Array = [0, 0, 0, 0]
var fire_upgrades: Array = [0, 0, 0, 0]
var bone_upgrades: Array = [0, 0, 0, 0]

#basic bullet upgrades
var skullsNumber: int = 1
var skull_damage: int = 100
var skull_kill_chance: float = 0.0
var bullet_fire_damage: bool = false
var bullet_fire_damage_damage: int = 15

#orbitting magic orbs upgrade
var orbitting_skulls_number = 0
var orbitting_orb_damage: int = 50
var orbitting_orb_knockback: int = 20
var orbitting_speed: int = 150

#chaining upgrades
var chaining_chance: float = 0
var chaining_damage: bool = false
var chaining_duration: int = 10
var chain_extra_xp: bool = false


#rain drops upgrades
var is_raining: bool = false
var rain_drops : int = 40
var rain_timer: float = 10
var rain_damage : int = 20

var extra_acid_rain_size: bool = false

var fire_ticks: int = 4

var fire_circle: bool = false
var fire_circle_return: bool = false
var fire_circle_damage: int = 30
var fire_circle_start_timer: float = 10

var volcanoes: bool = false
var volcano_count: int = 1
var volcano_shoots_twice: bool = false
var volcano_projectiles: int = 10
var volcano_start_timer: int = 15
var volcano_projectile_fire_damage: int = 50


var fire_pillars: bool = false
var fire_ring_spawn_fire_pillars: bool = false
var fire_pillars_count: int = 20
var fire_pillars_damage: int = 40
var fire_pillars_start_timer: float = 20.0
var fire_pillars_expire_timer: float = 10
var fire_pillar_homing: bool = false

var homing_flame_speed: float = 100
var homing_flame_damage: int = 20

var player_speed: float = 0
#skeleton upgrades
var spawn_skeleton_chance : float = 0.0
var skeleton_damage: int = 100
var skeleton_health: int = 2
var skeleton_speed: int = 50
var skeleton_drop_xp_chance: float = 0.0

var familiar1_is_active: bool = false
var familiar1_kill_enemy: bool = false
var familiar1_spawn_xp: bool = false
var familiar1_spawn_timer: float = 3.0

var familiar2_is_active: bool = false
var familiar2_spawn_skeleton: bool = false
var familiar2_spawn_tombstone: bool = false
var familiar2_spawn_timer: float = 3.0

var skeleton_hands: bool = false
var skeleton_hands_count: int = 10
var skeleton_hands_timer: float = 12
var skeleton_hands_spawn_skeleton: bool = false
var skeleton_hands_spawn_grave: bool = false

var middle_wall: bool = false
var front_wall: bool = false
var back_wall: bool = false
var wall_damage: int = 50
var wall_knock_force: int = 100
var wall_timer: float = 7
var skeleton_walls_spawn_grave: bool = false

#bonus damage upgrades
var bonus_damage : int = 0
var bonus_fire_damage: int = 0
var bonus_skull_damage: int = 0

var enemies_killed: int = 0

var heal_player: bool = false
var spawn_random_xp: bool = false
var spawn_fire_pillar: bool = false
var player_collection_radius: int = 100
var player_spawn_tombstone: bool = false
var player_dodge_chance: float = 0.0

var wizard_heal: bool = false

var drop_extra_xp_chance: float = 0.000

var swordman_health: int = 180
var ranger_health: int = 490
var knight_health: int = 700

var drop_health_orb_chance: float = 0.0
var drop_health_orb: bool = false

var homing_flame_spawn_pillar: bool = false

var time_finished: bool = false
var final_boss_defeated: bool = false

signal orbitting_skulls_number_changed(orbitting_skulls)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#book_open.hide()
	await get_tree().process_frame
	quit_button.hide()
	JoyStick = get_tree().get_first_node_in_group("JoyStick")
	var player = get_tree().get_first_node_in_group("Player")
	transition.finish_transition()
	scroll_container_parent.hide()
	icon_buttons_label.text = ""
	var rows = upgrade_icons_scroll_container.get_child(0).get_children()
	for child in rows:
		var buttons = child.get_children()
		for button in buttons:
			button.disabled = true
			button.modulate.a = 0.5
	rows[14].get_child(4).disabled = false
	rows[14].get_child(4).modulate.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		

func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()

func increment_kills():
	enemies_killed += 1
	ui_canvas_layer.update_kill_counter(enemies_killed)
	
func spawn_flame():
	var instance = flame.instantiate()
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	instance.global_position = player.global_position + Vector2(-50, -50)
	add_child(instance)


func _on_pause_button_pressed() -> void:
	pause_button.release_focus()
	if get_tree().paused == false:
		get_tree().paused = true
		quit_button.show()
		player_collection_radius_button.hide()
		scroll_container_parent.show()
		upgrade_icons_animation_player.play("UpgradeIconsShow")
		icon_buttons_label.text = ""
		book_close.visible = false
		book_open.visible = true
		JoyStick.visible = false
	else:
		get_tree().paused = false
		quit_button.hide()
		player_collection_radius_button.show()
		book_close.visible = true
		book_open.visible = false
		upgrade_icons_animation_player.play_backwards("UpgradeIconsShow")
		await upgrade_icons_animation_player.animation_finished
		scroll_container_parent.hide()
		JoyStick.visible = true
	
		



func _on_player_collection_radius_button_pressed() -> void:
	player_collection_radius_button.disabled = true
	player_collection_radius_button.modulate.a = 0.5
	await get_tree().create_timer(60).timeout
	player_collection_radius_button.disabled = false
	player_collection_radius_button.modulate.a = 1
	
func enable_upgrade_button(row: int, column: int):
	var upgrade_row = upgrade_icons_scroll_container.get_child(0).get_child(row)
	var button = upgrade_row.get_child(column)
	button.disabled = false
	button.modulate.a = 1
	pass

func hide_pause_button():
	pause_button.hide()
	player_collection_radius_button.hide()
	
func show_pause_button():
	pause_button.show()
	player_collection_radius_button.show()
	
	
func kill_entities():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.hide()
	var bullets = get_tree().get_nodes_in_group("Bullet")
	for bullet in bullets:
		bullet.hide()
	

func _on_texture_button_pressed() -> void:
	transition.start_transition2()


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
