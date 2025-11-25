extends Area2D

@export var speed : int = 100
@export var damage: int = 1

@onready var return_to_pool_timer: Timer = $ReturnToPoolTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#var player: CharacterBody2D
var distance
var closestPlayerCharacter: CharacterBody2D = null
var direction: Vector2
var poolManger
var has_collided : bool = false
var lookedAtPlayer: bool = false
var attackKnockBackForce: int = 200
var attackKnockBackTimer: float = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	poolManger = get_tree().get_first_node_in_group("Spawner")
	set_active(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	
	position += direction.normalized() * speed * delta
	
	
func get_closest_player() -> CharacterBody2D: 
	distance = INF
	var playerCharacters = get_tree().get_nodes_in_group("Player")
	for character in playerCharacters:
		var dist = (character.global_position - global_position).length()
		if dist < distance:
			distance = dist
			closestPlayerCharacter = character
	return closestPlayerCharacter

func set_active(is_active: bool):
	if is_active:
		return_to_pool_timer.start()
		closestPlayerCharacter = get_closest_player()
		## Determine direction when activated
		if closestPlayerCharacter != null:
			direction = (closestPlayerCharacter.global_position - global_position).normalized()
			if lookedAtPlayer == false:
				look_at(closestPlayerCharacter.global_position)
				lookedAtPlayer = true
		else:
			pass
			## If no player is found, move horizontally based on facing direction
			#direction = Vector2.RIGHT if !animated_sprite_2d.flip_h else Vector2.LEFT
			
			
		# Set valid collision layer and mask values to interact with other objects
		collision_layer = 2
		collision_mask = 1
		show()
	else:
		# Deactivate
		collision_layer = 0
		collision_mask = 0
		hide()


func return_to_pool():
	#print("Returning bullet to pool")  # Debug when the bullet is being returned to the pool
	set_active(false)
	has_collided = false
	distance = INF
	closestPlayerCharacter = null
	lookedAtPlayer = false
	poolManger.add_arrow_to_pool(self)
	animated_sprite_2d.flip_h = false

func _on_return_to_pool_timer_timeout() -> void:
	await get_tree().process_frame
	return_to_pool()

func _on_body_entered(body: Node2D) -> void:
	if has_collided:
		return  # Prevent further collisions once the bullet has collided with something
	body.take_damage(1, global_position, attackKnockBackForce, attackKnockBackTimer)
	has_collided = true  # Set the flag to true to prevent further collisions

	#print("Bullet hit: ", body.name)  # Debug the body hit
	#set_deferred("monitoring", false)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	
	await get_tree().process_frame
	return_to_pool()
