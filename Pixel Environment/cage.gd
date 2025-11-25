extends Node2D

@onready var top_left: Marker2D = $TopLeft
@onready var bottom_left: Marker2D = $BottomLeft
@onready var top_right: Marker2D = $TopRight
@onready var bottom_right: Marker2D = $BottomRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var posArray 

var spawner


var root
const SPIKY_MONOLITH = preload("res://Pixel Environment/spiky_monolith.tscn")
var spawnKnight: bool = false

const NUMBER_OF_MONOLYTHS_HORIZONTAL: int = 12
const NUMBER_OF_MONOLYTHS_VERTICAL: int = 12
const HORIZONTAL_DISTANCE: int = 125
const VERTICAL_DISTANCE: int = 50
const boss1 = preload("res://Enemies/Bosses/boss_1.tscn")
const boss2 = preload("res://Enemies/Bosses/boss_2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	root = get_tree().current_scene
	spawner = get_tree().get_first_node_in_group("Spawner")
	await get_tree().create_timer(0.5).timeout
	for i in range (NUMBER_OF_MONOLYTHS_HORIZONTAL):
		var monolyth_up = SPIKY_MONOLITH.instantiate()
		add_child(monolyth_up)
		monolyth_up.global_position = Vector2(i * HORIZONTAL_DISTANCE, -25) + self.global_position
		monolyth_up.animated_sprite_2d.flip_h = [true, false].pick_random()
		
		var monolyth_down = SPIKY_MONOLITH.instantiate()
		add_child(monolyth_down)
		monolyth_down.global_position = Vector2(i * HORIZONTAL_DISTANCE, (NUMBER_OF_MONOLYTHS_VERTICAL + 1) * VERTICAL_DISTANCE) + self.global_position
		monolyth_down.animated_sprite_2d.flip_h = [true, false].pick_random()
		
	for i in range(NUMBER_OF_MONOLYTHS_VERTICAL):
		var monolyth_left = SPIKY_MONOLITH.instantiate()
		add_child(monolyth_left)
		monolyth_left.global_position = Vector2(0, (i + 1) * VERTICAL_DISTANCE) + self.global_position
		monolyth_left.animated_sprite_2d.flip_h = [true, false].pick_random()
		
		var monolyth_right = SPIKY_MONOLITH.instantiate()
		add_child(monolyth_right)
		monolyth_right.global_position = Vector2((NUMBER_OF_MONOLYTHS_HORIZONTAL - 1) * HORIZONTAL_DISTANCE, (i + 1) * VERTICAL_DISTANCE) + self.global_position
		monolyth_right.animated_sprite_2d.flip_h = [true, false].pick_random()
		
		top_left.global_position = self.global_position + Vector2(HORIZONTAL_DISTANCE, 2 * VERTICAL_DISTANCE)
		top_right.global_position  = self.global_position + Vector2((NUMBER_OF_MONOLYTHS_HORIZONTAL - 2) * HORIZONTAL_DISTANCE + 30, 2 * VERTICAL_DISTANCE)
		bottom_right.global_position = self.global_position + Vector2((NUMBER_OF_MONOLYTHS_HORIZONTAL - 2) * HORIZONTAL_DISTANCE + 30, NUMBER_OF_MONOLYTHS_VERTICAL * VERTICAL_DISTANCE)
		bottom_left.global_position = self.global_position + Vector2(HORIZONTAL_DISTANCE, NUMBER_OF_MONOLYTHS_VERTICAL * VERTICAL_DISTANCE)

	posArray = [top_left.global_position, top_right.global_position, bottom_right.global_position, bottom_left.global_position]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func cage_level(level: int):
	if posArray == null:
		posArray = [top_left.global_position, top_right.global_position, bottom_right.global_position, bottom_left.global_position]
	var pos = posArray.pick_random()
	if level == 1:
		var bossInstace = boss1.instantiate()
		bossInstace.global_position = pos
		get_tree().current_scene.add_child(bossInstace)
	else:
		var bossInstace = boss2.instantiate()
		bossInstace.global_position = pos
		get_tree().current_scene.add_child(bossInstace)
		spawnKnight = true
		
		

func clear_cage():
	animation_player.play("FadeOut")
	


func _on_spawn_swordman_timer_timeout() -> void:
	spawner.spawn_swordman_position(root.swordman_health, posArray.pick_random())



func _on_spawn_archer_timer_timeout() -> void:
	spawner.spawn_ranger_position(posArray.pick_random())


func _on_spawn_knight_timer_timeout() -> void:
	if spawnKnight == true:
		spawner.spawn_big_knight_position(posArray.pick_random())
