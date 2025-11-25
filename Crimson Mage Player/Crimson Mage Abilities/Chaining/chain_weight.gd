extends Node2D

@onready var chain_1_right: Sprite2D = $Sphere2/Chain1Right
@onready var chain_2_right: Sprite2D = $Sphere2/Chain1Right/Chain2Right
@onready var chain_1_left: Sprite2D = $Sphere2/Chain1Left
@onready var chain_2_left: Sprite2D = $Sphere2/Chain1Left/Chain2Left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_chains_left() -> void:
	chain_1_left.show()
	chain_2_left.show()
	chain_1_right.hide()
	chain_2_right.hide()
	
func show_chains_right() -> void:
	chain_1_left.hide()
	chain_2_left.hide()
	chain_1_right.show()
	chain_2_right.show()
