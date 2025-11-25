extends PathFollow2D

@export var speed: int = 200

func _process(delta):
	progress += speed * delta  # Adjust speed
