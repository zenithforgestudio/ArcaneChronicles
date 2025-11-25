extends TextureRect

@export var max_length = 50
@export var dead_zone = 5

@onready var parent: Control = $".."

var pressing: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_length *= parent.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= max_length:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle) * max_length
			global_position.y = parent.global_position.y + sin(angle) * max_length
	else:
		global_position = lerp(global_position, parent.global_position, delta * 10)


func _on_joy_stick_button_button_down() -> void:
	pressing = true


func _on_joy_stick_button_button_up() -> void:
	pressing = false
