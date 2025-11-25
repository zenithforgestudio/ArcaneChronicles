extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hex_to_color(hex: String) -> Color:
	# Remove the '#' if it's included
	if hex.begins_with("#"):
		hex = hex.substr(1)

	# Ensure the hex string is exactly 6 characters (RGB)
	if hex.length() != 6:
		push_error("Hex color must be 6 characters long.")
		return Color(1, 1, 1)  # default to white

	var r = int("0x" + hex.substr(0, 2)) / 255.0
	var g = int("0x" + hex.substr(2, 2)) / 255.0
	var b = int("0x" + hex.substr(4, 2)) / 255.0

	return Color(r, g, b)
