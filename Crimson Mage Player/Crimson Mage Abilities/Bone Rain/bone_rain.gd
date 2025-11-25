extends Node2D

@export var boneNumbers: int = 20
@onready var bone_rain: Node2D = $"."

var player: CharacterBody2D
var length
var height
var rain_drop = [preload("res://Crimson Mage Player/Crimson Mage Abilities/Bone Rain/bone_fragment.tscn")]
var drop
var signx: int
var signy: int
var root
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	player = get_parent()
	root = get_tree().current_scene
	
	if root.extra_acid_rain_size == false:
		length = get_viewport_rect().size.x / 1.5
		height = get_viewport_rect().size.y / 1.5

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func rain_bones(playerPos: Vector2):
	for droplet in root.rain_drops:
		drop = rain_drop[randi() % rain_drop.size()].instantiate()
		signx = [-1, 1].pick_random()
		signy = [-1, 1].pick_random()
		drop.position = Vector2(playerPos.x + signx * randi_range(0, length), 
		playerPos.y + signy * randi_range(0, height) - 1.5 * height)
		get_tree().current_scene.add_child(drop)
		
