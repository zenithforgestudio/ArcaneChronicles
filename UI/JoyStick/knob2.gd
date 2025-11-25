extends Sprite2D

@export var maxLength = 70
@export var deadZone = 20

@onready var parent: Node2D = $".."

var pressing: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to((parent.global_position)) <= maxLength:
			global_position = get_global_mouse_position()


func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
