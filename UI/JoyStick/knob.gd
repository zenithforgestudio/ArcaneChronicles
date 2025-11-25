extends Sprite2D

@onready var parent: Node2D = $".."

@export var maxLength = 70
@export var deadZone = 20

var pressing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxLength *= parent.scale.x
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.y = parent.global_position.y + sin(angle) * maxLength
			global_position.x = parent.global_position.x + cos(angle) * maxLength
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, delta * 30)
		parent.posVector = Vector2.ZERO
		


func calculateVector():
	if abs((global_position.x - parent.global_position.x)) >= deadZone:
		parent.posVector.x = (global_position.x - parent.global_position.x) / maxLength
	if abs((global_position.y - parent.global_position.y)) >= deadZone:
		parent.posVector.y = (global_position.y - parent.global_position.y) / maxLength

func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
