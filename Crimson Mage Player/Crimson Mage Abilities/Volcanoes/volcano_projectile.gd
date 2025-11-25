extends Area2D

@onready var collision_timer: Timer = $CollisionTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var pool
var targe_position: Vector2
var time_to_reach_position: float = 1.2
var root
var pos: Vector2 = Vector2.ZERO
var launched: bool = false
var start_pos: Vector2
var end_pos: Vector2
var control_point: Vector2
var elapsed := 0.0
var moving := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	pool = get_tree().get_first_node_in_group("Spawner")
	root = get_tree().current_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		elapsed += delta
		var t = clamp(elapsed / time_to_reach_position, 0.0, 1.0)

		# Quadratic Bézier interpolation
		var a = lerp(start_pos, control_point, t)
		var b = lerp(control_point, end_pos, t)
		global_position = lerp(a, b, t)
		if end_pos.x > global_position.x:
			animated_sprite_2d.rotation = lerp(-PI/2, PI/2, t)
		else:
			animated_sprite_2d.rotation = lerp(-PI/2, -3*PI/2, t)
		if t >= 1.0:
			moving = false
			pool.spawn_pillar(self.global_position)
			return_to_pool()
		
	
	

func set_active(is_active: bool):
	if is_active:
		#animated_sprite_2d.play("default")
		animated_sprite_2d.play("Lava Ball")
		animated_sprite_2d.rotation = -90
		show()
		set_process(true)
		pos = Vector2.ZERO
		
	else:
		return_to_pool()
		
func return_to_pool():
	hide()
	set_process(false)
	collision_mask = 0
	pool.add_rock_to_pool(self)
	pos = Vector2.ZERO
	
func launch():
	set_active(true)
	collision_timer.start()
	while(pool == null):
		pool = get_parent()
	if pool:
		pos = Vector2(randf_range(global_position.x - 300, global_position.x + 300),
					randf_range(global_position.y - 150, global_position.y + 150))
	start_arc_move(pos)
	
	
func _on_collision_timer_timeout() -> void:
	collision_mask = 2


func _on_body_entered(body: Node2D) -> void:
	body.take_fire_damage(root.volcano_projectile_fire_damage, root.fire_ticks)
	pool.spawn_pillar(self.global_position)
	return_to_pool()
	
func start_arc_move(to: Vector2,):
	start_pos = global_position
	end_pos = pos
	var distance = start_pos.distance_to(end_pos)
	var arc_height = distance * 0.25
	var midpoint = (start_pos + end_pos) / 2
	control_point = midpoint - Vector2(0, arc_height)  # Raise the arc vertically
	elapsed = 0.0
	moving = true
