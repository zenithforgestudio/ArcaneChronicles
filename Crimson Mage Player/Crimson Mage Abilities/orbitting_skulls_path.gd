extends Path2D

@export var floating_skull_scene: PackedScene

var world_manager
var skulls_count: int = 0
var root

func _ready():
	await get_tree().process_frame
	root = get_tree().current_scene
	world_manager = get_tree().current_scene
	skulls_count = world_manager.orbitting_skulls_number
	world_manager.orbitting_skulls_number_changed.connect(_spawn_objects)
	curve = _create_circle_curve(100)  # Set circle radius to 100
	_spawn_objects(skulls_count)
	
func _physics_process(delta: float) -> void:
	for follower in get_children():
		follower.progress += root.orbitting_speed * delta

# Create a perfect circle curve
func _create_circle_curve(radius: float) -> Curve2D:
	var c = Curve2D.new()
	var steps = 32
	for i in range(steps):
		var angle = (i / float(steps)) * TAU
		c.add_point(Vector2(cos(angle) * radius, sin(angle) * radius))
	c.add_point(c.get_point_position(0))  # Close the circle
	return c

# Spawn objects equidistant along the path
func _spawn_objects(skulls_count):
	#clear pre existing skulls
	for path in get_children():
		path.queue_free()
	
	
	#spawn the orbitting skulls
	for i in range(skulls_count):
		var follower = PathFollow2D.new()
		follower.rotates = false
		add_child(follower)

		# Set progress ratio to space objects evenly
		follower.progress_ratio = float(i) / skulls_count

		# Add object to the follower
		var floating_skulls = floating_skull_scene.instantiate()
		follower.call_deferred("add_child", floating_skulls)
