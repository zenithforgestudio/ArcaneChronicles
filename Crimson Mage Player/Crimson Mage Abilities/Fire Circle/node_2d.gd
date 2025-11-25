extends Node2D

var current_radius := 0.0
var ring_thickness := 6.0

func _draw():
	var center = get_viewport_rect().size / 2.0
	draw_arc(center, current_radius, 0, TAU, 64, Color(1.0, 1.0, 1.0), ring_thickness)
