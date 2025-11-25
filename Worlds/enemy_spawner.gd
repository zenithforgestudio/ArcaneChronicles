extends Node2D


@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var swordman_spawn_timer: Timer = $SwordmanSpawnTimer
@onready var spawn_big_knight_timer: Timer = $SpawnBigKnightTimer
@onready var fire_pillars_spawn_timer: Timer = $FirePillarsSpawnTimer
@onready var spawn_volcano_timer: Timer = $SpawnVolcanoTimer
@onready var spawn_skeleton_hands_timer: Timer = $SpawnSkeletonHandsTimer
@onready var bone_wall_timer: Timer = $BoneWallTimer
@onready var spawn_squad_timer_2: Timer = $SpawnSquadTimer2
@onready var spawn_squad_timer_3: Timer = $SpawnSquadTimer3
@onready var spawn_ranger_timer: Timer = $SpawnRangerTimer
@onready var spawn_squad_timer_1: Timer = $SpawnSquadTimer1
@onready var boss_timer_2: Timer = $BossTimer2
@onready var spawn_demon_timer_1: Timer = $SpawnDemonTimer1
@onready var spawn_demon_timer_2: Timer = $SpawnDemonTimer2

var wizard = preload("res://NPC/wizzard_npc.tscn")
var demon = preload("res://NPC/demon_npc.tscn")
var swordman = preload("res://Enemies/swordman pack/melee_swordman.tscn")
var ranger = preload("res://Enemies/Huntress 2/Ranger1.tscn")
var knight = preload("res://Enemies/Knight 2/big_knight.tscn")
var hand = preload("res://Crimson Mage Player/Crimson Mage Abilities/Skeleton Hands/sekelton_hand.tscn")
const SPIKY_MONOLITH = preload("res://Pixel Environment/spiky_monolith.tscn")

var swordman_pool: Array = []
var ranger_pool: Array = []
var big_knight_pool: Array = []
var arrow_pool: Array = []
var skeleton_pool: Array =[]
var fire_pillar_pool: Array = []
var rock_pool: Array = []
var label_pool: Array = []
var skeleton_hands_pool: Array = []
var skeleton_walls_pool: Array = []
var tombstone_pool: Array = []

var player: CharacterBody2D
var root
var cageLevel = 1
var spawn_big_knight_time_left: float = 0 
var spawn_squad_timer_3_time_left: float = 0
var spawn_demon_timer_1_time_left: float = 0
var spawn_demon_timer_2_time_left: float = 0
var spawn_boss_2_time_time_left: float = 0

var half_horizontal: float
var half_vertical

var cage = preload("res://Pixel Environment/cage.tscn")
var volcano = preload("res://Crimson Mage Player/Crimson Mage Abilities/Volcanoes/volcano.tscn")
var health_orb = preload("res://Items/health_pick_up.tscn")

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	root = get_tree().current_scene
	await get_tree().create_timer(1).timeout
	spawn_squad_timer_1.start(60)
	spawn_ranger_timer.start(105)
	spawn_squad_timer_2.start(165)
	spawn_big_knight_timer.start(230)
	spawn_squad_timer_3.start(300)
	half_horizontal = get_viewport_rect().size.x / 2
	half_vertical = get_viewport_rect().size.y / 2



func spawn_health_orb(pos: Vector2):
	var health_orb_pick_up = health_orb.instantiate()
	health_orb_pick_up.global_position = pos
	root.add_child(health_orb_pick_up)

func spawn_wall(pos: Vector2):
	#var wall = get_skeleton_wall()
	var wall = get_skeleton_wall()
	wall.global_position = pos
	root.add_child(wall)
	wall.show()
	wall.set_active(true)
	
func get_skeleton_wall():
	if skeleton_walls_pool.size() > 0:
		var wall = skeleton_walls_pool.pop_back()
		wall.get_parent().remove_child(wall)
		wall.show()
		return wall
	else:
		var wall = preload("res://Crimson Mage Player/Crimson Mage Abilities/SkeletonWalls/skeleton_wall.tscn").instantiate()
		return wall
		
func add_skeleton_wall_to_pool(wall):
	wall.hide()
	skeleton_walls_pool.append(wall)
	
func spawn_tombstone(pos: Vector2, facing_right: bool):
	var tombstone = get_tombstone()
	tombstone.global_position = pos
	root.add_child(tombstone)
	tombstone.set_active(true, facing_right)
		
func get_tombstone():
	if tombstone_pool.size() > 0:
		var tombstone = tombstone_pool.pop_back()
		tombstone.get_parent().remove_child(tombstone)
		return tombstone
	else:
		var tombstone = preload("res://Crimson Mage Player/Crimson Mage Abilities/Tombstone/tombstone.tscn").instantiate()
		return tombstone
	
func add_tombstone_to_pool(tombstone):
	tombstone_pool.append(tombstone)

func spawn_swordman(health: int):
	# Instantiate an enemy from the PackedScene and position it at the path start
	var enemy = swordman.instantiate()
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = path_follow_2d.global_position
	enemy.health = root.swordman_health
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	


	
	
func spawn_label(enemy: CharacterBody2D) -> Label:
	var label = get_label()
	enemy.add_child(label)
	label.show()
	return label
	
func get_label() -> Label:
	if label_pool.size() > 0:
		var label = label_pool.pop_back()
		
		if !is_instance_valid(label):
			# If it was freed, don't return it
			return preload("res://UI/DamageLabel/take_damage_label.tscn").instantiate()

		# Safety: remove it from its parent, if needed
		if label.get_parent():
			label.get_parent().remove_child(label)
		
		label.show()
		return label

	else:
		return preload("res://UI/DamageLabel/take_damage_label.tscn").instantiate()

	
func add_label_to_pool(label: Label):
	label.hide()
	label_pool.append(label)

func spawn_skeleton_hand(pos: Vector2):
	var skeleton_hand = hand.instantiate()
	if pos == Vector2.ZERO:
		skeleton_hand.global_position = player.global_position + Vector2(randi_range(-300, 300), randi_range(-150, 150))
	else:
		skeleton_hand.global_position = pos
	skeleton_hand.show()
	root.add_child(skeleton_hand)
	

func spawn_ranger():
	var enemy = ranger.instantiate()
	enemy.health = root.ranger_health
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = path_follow_2d.global_position
	
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	
	if root.ranger_health < 500:
		root.ranger_health += 1
		
func spawn_ranger_position(pos: Vector2):
	var enemy = ranger.instantiate()
	enemy.health = root.ranger_health
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = pos
	
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	
	if root.ranger_health < 500:
		root.ranger_health += 1
	
	
func spawn_arrow(pos: Vector2):
	var arrow = get_arrow()
	arrow.global_position = pos
	get_tree().current_scene.add_child(arrow)
	arrow.set_active(true)
	arrow.show()
	
func get_arrow():
	if arrow_pool.size() > 0:
		var arrow = arrow_pool.pop_back()
		arrow.get_parent().remove_child(arrow)
		arrow.show()
		return arrow
	else:
		var arrow = preload("res://Enemies/Huntress 2/arrow_bullet.tscn").instantiate()
		return arrow
		
func add_arrow_to_pool(arrow: Area2D):
	arrow.hide()
	arrow_pool.append(arrow)
	
	
func spawn_big_knight():
	var enemy = knight.instantiate()
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = path_follow_2d.global_position
	enemy.health = root.knight_health
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	
	if root.knight_health < 999:
		root.knight_health += 2
	
func spawn_big_knight_position(pos: Vector2):
	var enemy = knight.instantiate()
	path_follow_2d.progress_ratio = randf()
	enemy.global_position = pos
	enemy.health = root.knight_health
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	
	if root.knight_health < 999:
		root.knight_health += 2
	
	
func spawn_skeleton(pos: Vector2):
	var ally = preload("res://Allies/resurrected_skeleton.tscn").instantiate()
	ally.position = pos
	get_tree().current_scene.add_child(ally)
	
	
#func get_skeleton():
	#if skeleton_pool.size() > 0:
		#var skeleton = skeleton_pool.pop_back()
		#skeleton.get_parent().remove_child(skeleton)
		#return skeleton
	#else:
		#var skeleton = preload("res://Allies/resurrected_skeleton.tscn").instantiate()
		#return skeleton
		#
#func add_skeleton_to_pool(skeleton: CharacterBody2D):
	#skeleton_pool.append(skeleton)
	
	
func spawn_pillar(pos: Vector2):
	call_deferred("add_fire_pillar", pos)
	
	
func add_fire_pillar(pos: Vector2):
	var fire_pillar = get_pillar()
	fire_pillar.position = pos
	root.add_child(fire_pillar)
	fire_pillar.set_active(true)
	
func get_pillar():
	if fire_pillar_pool.size() > 0:
		var pillar = fire_pillar_pool.pop_back()
		pillar.get_parent().remove_child(pillar)
		return pillar
	else:
		var pillar = preload("res://Crimson Mage Player/Crimson Mage Abilities/Fire Pillar/fire_pillar.tscn").instantiate()
		return pillar
		
func add_fire_pillar_to_pool(fire_pillar: Area2D):
	fire_pillar_pool.append(fire_pillar)
	#fire_pillars_spawn_timer.start(root.fire_pillars_start_timer)
	
	
func get_rock():
	if rock_pool.size() > 0:
		var rock = rock_pool.pop_back()
		rock.get_parent().remove_child(rock)
		rock.show()
		return rock
	else:
		var rock = preload("res://Crimson Mage Player/Crimson Mage Abilities/Volcanoes/volcano_projectile.tscn").instantiate()
		return rock
		
		
func spawn_rock(pos: Vector2):
	var rock = get_rock()
	rock.global_position = pos
	root.add_child(rock)
	rock.launch()
		
func add_rock_to_pool(rock):
	#rock.hide()
	rock_pool.append(rock)


	
func _on_spawn_timer_timeout() -> void:
	spawn_swordman(root.swordman_health)
	if root.swordman_health < 500:
		root.swordman_health += 1
	#if swordman_spawn_timer.wait_time > 0.5:
		#swordman_spawn_timer.wait_time -= 0.002
	if swordman_spawn_timer.wait_time > 0.2:
		swordman_spawn_timer.wait_time -= 0.001
	#print(swordman_spawn_timer.wait_time)
	#print("spawn swordman, " + str(swordman_spawn_timer.wait_time))
	swordman_spawn_timer.start(swordman_spawn_timer.wait_time)
	

func _on_spawn_ranger_timer_timeout() -> void:
	spawn_ranger()
	#spawn_ranger_timer.wait_time = 1.7505
	if root.ranger_health < 700:
		root.ranger_health += 2
	if spawn_ranger_timer.wait_time > 3:
		spawn_ranger_timer.wait_time = 3
	if spawn_ranger_timer.wait_time > 1:
		spawn_ranger_timer.wait_time -= 0.01
	spawn_ranger_timer.start(spawn_ranger_timer.wait_time)
	#print("spawn ranger, " + str(spawn_ranger_timer.wait_time))



func _on_spawn_big_knight_timer_timeout() -> void:
	spawn_big_knight()
	if root.knight_health < 1500:
		root.knight_health += 5
	#spawn_big_knight_timer.wait_time = 10
	#if spawn_big_knight_timer.wait_time > 5:
		#spawn_big_knight_timer.wait_time -= 0.01
	if spawn_big_knight_timer.wait_time > 5:
		spawn_big_knight_timer.wait_time = 5
	if spawn_big_knight_timer.wait_time > 0.5:
		spawn_big_knight_timer.wait_time -= 0.02
	spawn_big_knight_timer.start(spawn_big_knight_timer.wait_time)
	#print("spawn knight, " + str(spawn_big_knight_timer.wait_time))


func _on_test_timer_timeout() -> void:
	pass
	#spawn_skeleton(Vector2(randi_range(-100, 100) + player.position.x, randi_range(-100, 100) + player.position.y))


func _on_fire_pillars_spawn_timer_timeout() -> void:
	#fire_pillars_spawn_timer.start(root.fire_pillars_start_timer)
	#fire_pillars_spawn_timer.start(20)
	#print("fire pillar spawn timer worked")
	if root.fire_pillars == true:
		for i in range(0, root.fire_pillars_count):
			var signx = [-1, 1].pick_random()
			var signy = [-1, 1].pick_random()
			#print("fire pillar spawned")
			spawn_pillar(Vector2(
				player.global_position.x + signx * randi_range(50, get_viewport_rect().size.x / 2), 
				player.global_position.y + signy * randi_range(50, get_viewport_rect().size.y / 2)))
	fire_pillars_spawn_timer.start(root.fire_pillars_start_timer)


func _on_spawn_volcano_timer_timeout() -> void:
	#print("spawn volcano")
	if root.volcanoes == true:
		for i in range(root.volcano_count):
			var volcano_mountain = volcano.instantiate()
			volcano_mountain.global_position = player.global_position + Vector2(
			randi_range(-100, 100), randi_range(-100, 100))
			root.add_child(volcano_mountain)
			await get_tree().create_timer(0.2).timeout
	spawn_volcano_timer.start(root.volcano_start_timer)


func _on_spawn_skeleton_hands_timer_timeout() -> void:
	if root.skeleton_hands == true:
		var bodies = get_tree().get_nodes_in_group("Enemy")
		for i in range(root.skeleton_hands_count):
			var enemy_pos: Vector2 = Vector2.ZERO
			var target_enemy = null
			var found: bool = false
			for enemy in bodies:
				if enemy.handTargeted == false and abs(enemy.global_position - player.global_position).length() < 500 and found == false:
					enemy_pos = enemy.global_position
					target_enemy = enemy
					enemy.handTargeted = true
					found = true
			if target_enemy != null:
				if "direction" in target_enemy and target_enemy.direction != null:
					spawn_skeleton_hand(enemy_pos + target_enemy.direction.normalized() * 75)

			else:
				spawn_skeleton_hand(Vector2.ZERO)
	spawn_skeleton_hands_timer.start(root.skeleton_hands_timer)


func _on_bone_wall_timer_timeout() -> void:
	if root.front_wall == true:
		if player.animated_sprite_2d.flip_h == false:
			spawn_wall(player.global_position + Vector2(150, -150))
		else:
			spawn_wall(player.global_position + Vector2(-150, -150))
			
	await get_tree().create_timer(0.5).timeout
	
	if root.middle_wall == true:
		spawn_wall(player.global_position + Vector2(0, -150))
		
	await get_tree().create_timer(0.5).timeout
		
	if root.back_wall == true:
		if player.animated_sprite_2d.flip_h == false:
			spawn_wall(player.global_position + Vector2(-150, -150))
		else:
			spawn_wall(player.global_position + Vector2(150, -150))
			
	await get_tree().create_timer(0.5).timeout
		
	bone_wall_timer.start(root.wall_timer)


func _on_spawn_npc_timer_timeout() -> void:
	var wizard_instance = wizard.instantiate()
	wizard_instance.global_position = player.global_position + Vector2(0, -150)
	root.add_child(wizard_instance)
	
	
func _on_boss_timer_timeout() -> void:
	var cageInstance = cage.instantiate()
	cageInstance.global_position = player.global_position - Vector2(get_viewport_rect().size.x / 2 + 50, get_viewport_rect().size.y / 2 + 50)
	root.add_child(cageInstance)
	cageInstance.cage_level(cageLevel)
	cageLevel += 1
	
	spawn_big_knight_time_left = spawn_big_knight_timer.time_left
	spawn_squad_timer_3_time_left = spawn_squad_timer_3.time_left
	spawn_demon_timer_1_time_left = spawn_demon_timer_1.time_left
	spawn_demon_timer_2_time_left = spawn_demon_timer_2.time_left
	spawn_boss_2_time_time_left = boss_timer_2.time_left
	
	swordman_spawn_timer.stop()
	spawn_ranger_timer.stop()
	spawn_big_knight_timer.stop()
	spawn_squad_timer_1.stop()
	spawn_squad_timer_2.stop()
	spawn_squad_timer_3.stop()
	spawn_demon_timer_1.stop()
	spawn_demon_timer_2.stop()
	boss_timer_2.stop()
	


func start_timers():
	swordman_spawn_timer.start(swordman_spawn_timer.wait_time)
	spawn_ranger_timer.start(spawn_ranger_timer.wait_time)
	spawn_big_knight_timer.start(spawn_big_knight_time_left)
	spawn_squad_timer_1.start(spawn_squad_timer_1.wait_time)
	spawn_squad_timer_2.start(spawn_squad_timer_2.wait_time)
	spawn_squad_timer_3.start(spawn_squad_timer_3_time_left)
	spawn_demon_timer_1.start(spawn_demon_timer_1_time_left)
	spawn_demon_timer_2.start(spawn_demon_timer_2.time_left)
	boss_timer_2.start(spawn_boss_2_time_time_left)

	
func spawn_swordman_position(health: int, pos: Vector2):
	# Instantiate an enemy from the PackedScene and position it at the path start
	var enemy = swordman.instantiate()
	enemy.global_position = pos
	enemy.health = root.swordman_health
	get_tree().current_scene.add_child(enemy)
	enemy.show()
	if root.swordman_health < 500:
		root.swordman_health += 1

func spawn_squad(middleSquadPos: Vector2, swordmanCount: int, archerCount: int, knightCount: int):
	var enemiesCount = swordmanCount + archerCount + knightCount
	if enemiesCount % 2 == 0:
		for i in range(2):
			spawn_swordman_position(root.swordman_health, middleSquadPos + i * Vector2(20, 20))
	else:
		for i in range(enemiesCount):
			if i == 4:
				spawn_big_knight_position(middleSquadPos)
			elif i % 2 == 0:
				spawn_ranger_position(middleSquadPos + i * Vector2(0, 20))
			else:
				spawn_swordman_position(root.swordman_health, middleSquadPos + i * Vector2(20, 20))

func _on_spawn_squad_timer_timeout() -> void:
	path_follow_2d.progress_ratio = randf()
	var pos = path_follow_2d.global_position
	spawn_squad(pos, 2, 0, 0)
	if spawn_squad_timer_1.wait_time > 5:
		spawn_squad_timer_1.wait_time = 5
	if spawn_squad_timer_1.wait_time > 1.05 and spawn_squad_timer_1.wait_time <= 5:
		spawn_squad_timer_1.wait_time -= 0.05
	#print("spawn squad1, " + str(spawn_squad_timer_1.wait_time))
	spawn_squad_timer_1.start(spawn_squad_timer_1.wait_time)
	

func _on_spawn_squad_timer_2_timeout() -> void:
	path_follow_2d.progress_ratio = randf()
	var pos = path_follow_2d.global_position
	spawn_squad(pos, 2, 1, 0)
	if spawn_squad_timer_2.wait_time > 20:
		spawn_squad_timer_2.wait_time = 20
	if spawn_squad_timer_2.wait_time > 5 and spawn_squad_timer_2.wait_time <= 20:
		spawn_squad_timer_2.wait_time -= 0.1 
	#print("spawn squad2, " + str(spawn_squad_timer_2.wait_time))

	spawn_squad_timer_2.start(spawn_squad_timer_2.wait_time)

func _on_spawn_squad_timer_3_timeout() -> void:
	path_follow_2d.progress_ratio = randf()
	var pos = path_follow_2d.global_position
	spawn_squad(pos, 1, 2, 2)
	if spawn_squad_timer_3.wait_time > 20:
		spawn_squad_timer_3.wait_time = 20
	if spawn_squad_timer_3.wait_time > 7 and spawn_squad_timer_3.wait_time <= 20:
		spawn_squad_timer_3.wait_time -= 0.2 
	#print("spawn squad3, " + str(spawn_squad_timer_3.wait_time))

	spawn_squad_timer_3.start(spawn_squad_timer_3.wait_time)


func _on_spawn_demon_timer_1_timeout() -> void:
	var demonInstance = demon.instantiate()
	demonInstance.global_position = player.global_position + Vector2(0, -200)
	root.add_child(demonInstance)


func _on_spawn_demon_timer_2_timeout() -> void:
	var demonInstance = demon.instantiate()
	demonInstance.global_position = player.global_position + Vector2(0, -200)
	root.add_child(demonInstance)


func _on_spawn_monolyth_timer_timeout() -> void:
	var monolyth = SPIKY_MONOLITH.instantiate()
	var good_pos: bool = false
	var pos: Vector2
	while(good_pos == false):
		pos = player.global_position + Vector2(randi_range(-half_horizontal, half_horizontal), randi_range(-half_vertical, half_vertical))
		if (player.global_position - pos).length() > 150:
			good_pos = true
			
	monolyth.global_position = pos
	await get_tree().process_frame
	root.add_child(monolyth)
	monolyth.animated_sprite_2d.flip_h = [true, false].pick_random()
	monolyth.destroy_timer(30)


func _on_boss_timer_2_timeout() -> void:
	var cageInstance = cage.instantiate()
	cageInstance.global_position = player.global_position - Vector2(get_viewport_rect().size.x / 2 + 50, get_viewport_rect().size.y / 2 + 50)
	root.add_child(cageInstance)
	cageInstance.cage_level(cageLevel)
	cageLevel += 1
	
	swordman_spawn_timer.stop()
	spawn_ranger_timer.stop()
	spawn_big_knight_timer.stop()
	spawn_squad_timer_1.stop()
	spawn_squad_timer_2.stop()
	spawn_squad_timer_3.stop()
