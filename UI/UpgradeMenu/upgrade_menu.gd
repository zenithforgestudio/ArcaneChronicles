extends Control

@onready var h_box_container: HBoxContainer = $MarginContainer/Panel/VBoxContainer/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $MarginContainer/Panel/VBoxContainer/HBoxContainer2
@onready var title_label: Label = $MarginContainer/Panel/VBoxContainer/TitleLabel
@onready var reroll_button: TextureButton = $MarginContainer/Panel/VBoxContainer/HBoxContainer2/RerollButton
@onready var book_animation_sprite: AnimatedSprite2D = $MarginContainer/Control/BookAnimationSprite
@onready var book_animation_player: AnimationPlayer = $MarginContainer/Control/BookAnimationSprite/BookAnimationPlayer

var upgrade_scene: PackedScene
var upgrade_instance
var spacer 
var spacer2 
var upgrades_showed: int = 0
var JoyStick




var bullet: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/SkullBulletUpgradeCards/skull_bullet_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkullBulletUpgradeCards/skull_bullet_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkullBulletUpgradeCards/skull_bullet_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkullBulletUpgradeCards/skull_bullet_upgrade_card_1.tscn")]
	
	
var magic_orbs: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/MagicOrbsUpgradeCards/magic_orbs_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/MagicOrbsUpgradeCards/magic_orbs_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/MagicOrbsUpgradeCards/magic_orbs_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/MagicOrbsUpgradeCards/magic_orbs_upgrade_card_1.tscn")]
	
	
var acid_rain: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/AcidRainUpgradeCards/acid_rain_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/AcidRainUpgradeCards/acid_rain_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/AcidRainUpgradeCards/acid_rain_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/AcidRainUpgradeCards/acid_rain_upgrade_card_1.tscn")]
	
var chains: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/ChainWeightUpgradeCards/chain_weight_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/ChainWeightUpgradeCards/chain_weight_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/ChainWeightUpgradeCards/chain_weight_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/ChainWeightUpgradeCards/chain_weight_upgrade_card_1.tscn")
]

var fire_ring: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/FireRingUpgradeCards/fire_ring_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FireRingUpgradeCards/fire_ring_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FireRingUpgradeCards/fire_ring_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FireRingUpgradeCards/fire_ring_upgrade_card_1.tscn")
]

var volcano: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/VolcanoUpgradeCards/volcano_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/VolcanoUpgradeCards/volcano_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/VolcanoUpgradeCards/volcano_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/VolcanoUpgradeCards/volcano_upgrade_card_1.tscn")
]

var fire_pillars: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/FirePillarsUpgradeCards/fire_pillars_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FirePillarsUpgradeCards/fire_pillars_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FirePillarsUpgradeCards/fire_pillars_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FirePillarsUpgradeCards/fire_pillars_upgrade_card_1.tscn")
]

var flame: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/HomingFlameUpgradeCards/homing_flame_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/HomingFlameUpgradeCards/homing_flame_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/HomingFlameUpgradeCards/homing_flame_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/HomingFlameUpgradeCards/homing_flame_upgrade_card_1.tscn")
]

var familiar: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/FamiliarUpgradeCards/familiar_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FamiliarUpgradeCards/familiar_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FamiliarUpgradeCards/familiar_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/FamiliarUpgradeCards/familiar_upgrade_card_1.tscn")
]

var skeletons: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonsUpgradeCards/raised_skeleton_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonsUpgradeCards/raised_skeleton_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonsUpgradeCards/raised_skeleton_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonsUpgradeCards/raised_skeleton_upgrade_card_1.tscn")
]

var skeletal_hands: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonHandsCards/skeleton_hands_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonHandsCards/skeleton_hands_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonHandsCards/skeleton_hands_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/SkeletonHandsCards/skeleton_hands_upgrade_card_1.tscn")
]

var bone_walls: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/BoneWallUpgradeCards/bone_wall_upgrade_card_4.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/BoneWallUpgradeCards/bone_wall_upgrade_card_3.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/BoneWallUpgradeCards/bone_wall_upgrade_card_2.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/BoneWallUpgradeCards/bone_wall_upgrade_card_1.tscn")
]

var random_upgrades: Array = [
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/bullet_fire_damage_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/heal_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/spawn_xp_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/spawn_fire_pillar_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/move_speed_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/increase_collection_radius_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/spawn_tombstone_upgrade_card.tscn"),
	preload("res://UI/UpgradeMenu/UpgradeCards/RandomUpgrades/dodge_chance_upgrade_card.tscn")
]

var empty_upgrade_card = preload("res://UI/UpgradeMenu/UpgradeCards/empty_upgrade_card.tscn")


var wizzard_upgrades: Array = [
	preload("res://UI/UpgradeMenu/WizardUpgradeCards/wizard_upgrade_card_heal.tscn"),
	preload("res://UI/UpgradeMenu/WizardUpgradeCards/wizard_upgrade_card_necromancer.tscn"),
	preload("res://UI/UpgradeMenu/WizardUpgradeCards/wizard_upgrade_card_pyromancer.tscn"),
	preload("res://UI/UpgradeMenu/WizardUpgradeCards/wizard_upgrade_card_arcane.tscn")
]

var demon_upgrades: Array = [
	
]



var all_branches: Array = [bullet, magic_orbs, acid_rain, chains,
fire_ring, volcano, fire_pillars, flame,
familiar, skeletons, skeletal_hands, bone_walls]

var basic_branches: Array = []
var fire_branches: Array = []
var necromancer_branches: Array = []

var basic_branches_copy: Array = []
var fire_branches_copy: Array = []
var necromancer_branches_copy: Array = []

var basic_branches_copy_copy: Array = []
var fire_branches_copy_copy: Array = []
var necromancer_branches_copy_copy: Array = []

var random_upgrades_copy: Array = []
var random_upgrades_copy_copy: Array = []

var random_upgrade_card_index: int



var demon_arcane_branch: Array = [
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_basic_bullet.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_chain.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_magic_orbs.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_rain.tscn")]
	
var demon_piromancer_branch: Array = [
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/PyromancerBranch/demon_upgrade_homing_flame.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/PyromancerBranch/demon_upgrade_fire_ring.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/PyromancerBranch/demon_upgrade_volcanoes.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/PyromancerBranch/demon_upgrade_fire_ring.tscn")
]

var demon_necromancer_branch: Array = [
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/NecromancerBranch/demon_upgrade_familiars.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/NecromancerBranch/demon_upgrade_bone_walls.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/NecromancerBranch/demon_upgrade_raised_skeleton.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/NecromancerBranch/demon_upgrade_skeleton_hand.tscn")
]

var demon_healer_branch: Array = [
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_heal.tscn"),
	preload("res://UI/UpgradeMenu/DemonUpgradeCards/ArcaneBranch/demon_upgrade_health_drop.tscn"),
	]

var demon_upgrade_branches: Array = [demon_arcane_branch, demon_piromancer_branch, demon_necromancer_branch, demon_healer_branch]

func _ready() -> void:
	await get_tree().process_frame
	JoyStick = get_tree().get_first_node_in_group("JoyStick")

func random_permutation(permutation: Array) -> Array:
	var copy = permutation.duplicate(true)
	copy.shuffle()
	return copy
	

func show_upgrades():
	get_tree().paused = true
	title_label.text = "Level Up! Choose an Upgrade!"
	
	JoyStick.hide()
	
	basic_branches.clear()
	fire_branches.clear()
	necromancer_branches.clear()
	
	basic_branches_copy.clear()
	fire_branches_copy.clear()
	necromancer_branches_copy.clear()
	
	random_upgrades_copy.clear()
	random_upgrades_copy_copy.clear()
	
	
	if bullet.size() > 0:
		basic_branches.push_back(bullet)
	if magic_orbs.size() > 0:
		basic_branches.push_back(magic_orbs)
	if acid_rain.size() > 0:
		basic_branches.push_back(acid_rain)
	if chains.size() > 0:
		basic_branches.push_back(chains)
		
	if fire_ring.size()> 0 :
		fire_branches.push_back(fire_ring)
	if volcano.size() > 0:
		fire_branches.push_back(volcano)
	if fire_pillars.size() > 0:
		fire_branches.push_back(fire_pillars)
	if flame.size() > 0:
		fire_branches.push_back(flame)
		
	if familiar.size() > 0:
		necromancer_branches.push_back(familiar)
	if skeletons.size() > 0:
		necromancer_branches.push_back(skeletons)
	if skeletal_hands.size() > 0:
		necromancer_branches.push_back(skeletal_hands)
	if bone_walls.size() > 0:
		necromancer_branches.push_back(bone_walls)
		
	
	for child in h_box_container.get_children():
		child.queue_free()
		
	h_box_container_2.hide()
	title_label.hide()
		
	book_animation_sprite.play("default")
	await book_animation_sprite.animation_finished
		
	title_label.show()
	reroll_button.show()
	
	spacer = Control.new()
	h_box_container.add_child(spacer)

	h_box_container_2.show()
	title_label.show()
	h_box_container.show()
	
	upgrades_showed = 0
	
	for i in range(4):
		if i == 0:
			if basic_branches.size() > 0:
				basic_branches_copy = basic_branches.duplicate(true)
				var branch = basic_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				upgrades_showed += 1
				basic_branches_copy.erase(branch)
		elif i == 1:
			if fire_branches.size() > 0:
				fire_branches_copy = fire_branches.duplicate(true)
				var branch = fire_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				upgrades_showed += 1
				fire_branches_copy.erase(branch)
		elif i == 2:
			if necromancer_branches.size() > 0:
				necromancer_branches_copy = necromancer_branches.duplicate(true)
				var branch = necromancer_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				upgrades_showed += 1
				necromancer_branches_copy.erase(branch)
		elif i == 3:
			if random_upgrades.size() > 0:
				random_upgrades_copy = random_upgrades.duplicate(true)
				var upgrade_scene = random_upgrades.pick_random()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				#random_upgrades.push_back(upgrade_scene)
				random_upgrades_copy.erase(upgrade_scene)
				
	
	spacer2 = Control.new()
	h_box_container.add_child(spacer2)


func show_wizard_upgrades():
	title_label.text = "Choose an upggrade for your journey"
	
	JoyStick.hide()
	
	reroll_button.hide()
	
	for child in h_box_container.get_children():
		child.queue_free()
		
	h_box_container_2.hide()
	title_label.hide()
		
	book_animation_sprite.play("default")
	await book_animation_sprite.animation_finished
		
	title_label.show()
	
	spacer = Control.new()
	h_box_container.add_child(spacer)

	h_box_container_2.show()
	title_label.show()
	h_box_container.show()
	
	for i in range(wizzard_upgrades.size()):
		var upgrade_card = wizzard_upgrades[i]
		var upgrade_instance = upgrade_card.instantiate()
		h_box_container.add_child(upgrade_instance)
		
		
	for i in range(4 - wizzard_upgrades.size()):
		var updgrade_card = empty_upgrade_card
		var upgrade_instance = updgrade_card.instantiate()
		h_box_container.add_child(upgrade_instance)
		
	spacer2 = Control.new()
	h_box_container.add_child(spacer2)
	

func show_demon_upgrades():
	title_label.text = "Pay the price for power"
	
	JoyStick.hide()
	
	reroll_button.hide()
	
	for child in h_box_container.get_children():
		child.queue_free()
		
	h_box_container_2.hide()
	title_label.hide()
		
	book_animation_sprite.play("default")
	await book_animation_sprite.animation_finished
		
	title_label.show()
	
	spacer = Control.new()
	h_box_container.add_child(spacer)

	h_box_container_2.show()
	title_label.show()
	h_box_container.show()
	
	for i in range(demon_upgrade_branches.size()):
		var upgrade_card = demon_upgrade_branches[i].pick_random()
		if upgrade_card != null:
			upgrade_instance = upgrade_card.instantiate()
			h_box_container.add_child(upgrade_instance)
		
	spacer2 = Control.new()
	
	h_box_container.add_child(spacer2)

func close():
	title_label.hide()
	reroll_button.hide()
	h_box_container.hide()
	book_animation_player.play("Dissolve")
	await book_animation_player.animation_finished
	hide()
	book_animation_player.play("Reset")
	get_tree().paused = false
	JoyStick.show()
	
	
	
func _on_reroll_button_pressed() -> void:
	show_upgrades_without_animation()
	
func show_upgrades_without_animation():
	title_label.text = "Level Up! Choose an Upgrade!"
	
	JoyStick.hide()

	
	for child in h_box_container.get_children():
		child.queue_free()
		
	h_box_container_2.hide()
	title_label.hide()
		
		
	title_label.show()
	reroll_button.show()
	
	spacer = Control.new()
	h_box_container.add_child(spacer)

	h_box_container_2.show()
	title_label.show()
	h_box_container.show()
	
	upgrades_showed = 0
	
	for i in range(4):
		if i == 0:
			if basic_branches_copy.size() > 0:
				basic_branches_copy_copy = basic_branches.duplicate(true)
				var branch = basic_branches_copy.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				basic_branches_copy_copy.erase(branch)
				basic_branches_copy = basic_branches_copy_copy.duplicate(true)
			elif basic_branches.size() > 0:
				var branch = basic_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
			else:
				var upgrade_scene = empty_upgrade_card
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container_2.add_child(upgrade_instance)
				
		elif i == 1:
			if fire_branches_copy.size() > 0:
				fire_branches_copy_copy = fire_branches.duplicate(true)
				var branch = fire_branches_copy.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				fire_branches_copy_copy.erase(branch)
				fire_branches_copy = fire_branches_copy_copy.duplicate(true)
			elif fire_branches.size() > 0:
				var branch = fire_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
			else:
				var upgrade_scene = empty_upgrade_card
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container_2.add_child(upgrade_instance)
				
		elif i == 2:
			if necromancer_branches_copy.size() > 0:
				necromancer_branches_copy_copy = necromancer_branches.duplicate(true)
				var branch = necromancer_branches_copy.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
				necromancer_branches_copy_copy.erase(branch)
				necromancer_branches_copy = necromancer_branches_copy_copy.duplicate(true)
			elif necromancer_branches.size() > 0:
				var branch = necromancer_branches.pick_random()
				upgrade_scene = branch.pop_back()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				branch.push_back(upgrade_scene)
			else:
				var upgrade_scene = empty_upgrade_card
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container_2.add_child(upgrade_instance)
				
		elif i == 3:
			if random_upgrades_copy.size() > 0:
				#random_upgrades_copy = random_upgrades.duplicate(true)
				var upgrade_scene = random_upgrades_copy.pick_random()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
				#random_upgrades.push_back(upgrade_scene)
				random_upgrades_copy_copy = random_upgrades.duplicate()
				random_upgrades_copy_copy.erase(upgrade_scene)
				random_upgrades_copy = random_upgrades_copy_copy.duplicate(true)
			elif random_upgrades.size() > 0:
				var upgrade_scene = random_upgrades.pick_random()
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container.add_child(upgrade_instance)
			else:
				var upgrade_scene = empty_upgrade_card
				upgrade_instance = upgrade_scene.instantiate()
				h_box_container_2.add_child(upgrade_instance)
	
	spacer2 = Control.new()
	h_box_container.add_child(spacer2)
