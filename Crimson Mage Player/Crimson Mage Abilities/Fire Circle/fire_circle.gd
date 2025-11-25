extends Node2D

@export var ring_thickness := 6.0
@export var growth_duration := 4.0

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var fire_circle_sprite: Sprite2D = $FireCircleSprite
@onready var arc_drawer: Node2D = $FireCircleViewport/ArcDrawer


var current_radius := 0.0
var max_radius := 0.0
var elapsed := 0.0
var growing := true
var root
var spawner

func _ready():
	await get_tree().process_frame
	root = get_tree().current_scene
	spawner = get_tree().get_first_node_in_group("Spawner")
	max_radius = get_viewport().size.y * 0.15
	current_radius = 0.0
	elapsed = 0.0
	growing = true
	fire_circle_sprite.scale = Vector2(0.01, 0.01)
	set_process(true)
	collision_shape_2d.shape.radius = 20

func _process(delta):
	if growing:
		elapsed += delta
		var t = clamp(elapsed / growth_duration, 0.0, 1.0)
		current_radius = t * max_radius
		collision_shape_2d.shape.radius = current_radius
		var scale_t = lerp(0.01, 5.0, t)
		fire_circle_sprite.scale = Vector2(scale_t, scale_t)
		
		# Update the arc's radius (in viewport space)
		#arc_drawer.set("current_radius", t * 32.0)  # 32.0 is max radius for 64x64
		arc_drawer.set("current_radius", current_radius)

		arc_drawer.queue_redraw()

		if t >= 1.0 or current_radius >= max_radius:
			growing = false
			hide()
			spawn_fire_pillars()
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if is_instance_valid(body):
			if root == null:
				root = get_tree().current_scene
			body.take_fire_damage(root.fire_circle_damage, root.fire_ticks)

func spawn_fire_pillars():
	if root.fire_ring_spawn_fire_pillars == true:
		for i in range(8):
			var angle = i * TAU / 8
			var offset = Vector2(cos(angle), sin(angle)) * max_radius
			spawner.spawn_pillar(self.global_position + offset)
