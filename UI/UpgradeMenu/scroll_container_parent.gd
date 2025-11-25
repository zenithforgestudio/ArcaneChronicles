extends Control

@onready var icon_buttons_label: Label = $IconButtonsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_skull_bullet_icon_1_pressed() -> void:
	icon_buttons_label.text = "Add another skull to your basic attack"


func _on_skull_bullet_icon_2_pressed() -> void:
	icon_buttons_label.text = "Add 2 more skulls to your basic attack"


func _on_skull_bullet_icon_3_pressed() -> void:
	icon_buttons_label.text = "Double skull damage"



func _on_skull_bullet_icon_4_pressed() -> void:
	icon_buttons_label.text = "Skull have a 20% chance to instanly kill an enemy"


func _on_skull_bullet_icon_5_pressed() -> void:
	icon_buttons_label.text = "Killing an enemy with basic attack can spawn xp orb"


func _on_magic_orb_icon_1_pressed() -> void:
	icon_buttons_label.text = "Add a magic orb around the player"

func _on_magic_orb_icon_2_pressed() -> void:
	icon_buttons_label.text = "Add  an extra orb and increase orb damage"


func _on_magic_orb_icon_3_pressed() -> void:
	icon_buttons_label.text = "Add 1 extra orb around the player"


func _on_magic_orb_icon_4_pressed() -> void:
	icon_buttons_label.text = "Increase knock force and add another orb"


func _on_magic_orb_icon_5_pressed() -> void:
	icon_buttons_label.text = "Increase speed, reduce damage and knockback"


func _on_chain_icon_1_pressed() -> void:
	icon_buttons_label.text = "Basic attack chains enemies down"

func _on_chain_icon_2_pressed() -> void:
	icon_buttons_label.text = "Chained enemies take more damage"


func _on_chain_icon_3_pressed() -> void:
	icon_buttons_label.text = "Enemies take longer to escape chains"


func _on_chain_icon_4_pressed() -> void:
	icon_buttons_label.text = "Chained enemies drop an extra xp point"


func _on_chain_icon_5_pressed() -> void:
	icon_buttons_label.text = "Enemies stay chained forever"


func _on_acid_rain_icon_1_pressed() -> void:
	icon_buttons_label.text = "Acid rain will start to fall from the sky"


func _on_acid_rain_icon_2_pressed() -> void:
	icon_buttons_label.text = "Increase the number of rain drops"


func _on_acid_rain_icon_3_pressed() -> void:
	icon_buttons_label.text = "Increase rain drops damage"


func _on_acid_rain_icon_4_pressed() -> void:
	icon_buttons_label.text = "Rain spawns more often"


func _on_acid_rain_icon_5_pressed() -> void:
	icon_buttons_label.text = "Incrase rain size and drops number"


func _on_fire_circle_image_1_pressed() -> void:
	icon_buttons_label.text = "Spawn a fire ring that grows and burns enemies"


func _on_fire_circle_image_2_pressed() -> void:
	icon_buttons_label.text = "The fire ring deals more fire damage"


func _on_fire_circle_image_3_pressed() -> void:
	icon_buttons_label.text = "Further increase fire ring fire damage"


func _on_fire_circle_image_4_pressed() -> void:
	icon_buttons_label.text = "Fire rings spawns faster"


func _on_fire_circle_image_5_pressed() -> void:
	icon_buttons_label.text = "Fire circle leaves behind fire pillars"


func _on_volcano_icon_1_pressed() -> void:
	icon_buttons_label.text = "Spawn a volcano that shoots flaming rocks"


func _on_volcano_icon_2_pressed() -> void:
	icon_buttons_label.text = "Volcanoes will spawn faster now"


func _on_volcano_icon_3_pressed() -> void:
	icon_buttons_label.text = "Volcanoes shoot more projectiles"


func _on_volcano_icon_4_pressed() -> void:
	icon_buttons_label.text = "Volcanoes shoot twice the number of rocks"


func _on_volcano_icon_5_pressed() -> void:
	icon_buttons_label.text = "Spawn 2 volcanoes instead of 1"


func _on_fire_pillar_icon_1_pressed() -> void:
	icon_buttons_label.text = "Spawn fire pillars on the map"


func _on_fire_pillar_icon_2_pressed() -> void:
	icon_buttons_label.text = "Increase the number of fire pillars spawning"

func _on_fire_pillar_icon_3_pressed() -> void:
	icon_buttons_label.text = "Increase fire pillars damage"


func _on_fire_pillar_icon_4_pressed() -> void:
	icon_buttons_label.text = "Fire pillars now burn for longer time"


func _on_fire_pillar_icon_5_pressed() -> void:
	icon_buttons_label.text = "Fire pillars move towards closest enemy"


func _on_homing_flame_icon_1_pressed() -> void:
	icon_buttons_label.text = "A magic flame will start following and burning enemies"


func _on_homing_flame_icon_2_pressed() -> void:
	icon_buttons_label.text = "Increase flame damage"


func _on_homing_flame_icon_3_pressed() -> void:
	icon_buttons_label.text = "Further increase flame damage"


func _on_homing_flame_icon_4_pressed() -> void:
	icon_buttons_label.text = "The flame moves even faster now"


func _on_homing_flame_icon_5_pressed() -> void:
	icon_buttons_label.text = "Homing flame leaves behind fire pillars"


func _on_familiar_icon_1_pressed() -> void:
	icon_buttons_label.text = "Spawn a familiar that kills enemies"


func _on_familiar_icon_2_pressed() -> void:
	icon_buttons_label.text = "Get a familiar that spawns skeletons"


func _on_familiar_icon_3_pressed() -> void:
	icon_buttons_label.text = "First familiar also spawns xp drops"


func _on_familiar_icon_4_pressed() -> void:
	icon_buttons_label.text = "The second familiar also spawns tombstones"


func _on_familiar_icon_5_pressed() -> void:
	icon_buttons_label.text = "Both familiars activate their abilities faster"


func _on_skeleton_icon_1_pressed() -> void:
	icon_buttons_label.text = "Enemies have a chance to spawn a skeleton on death"


func _on_skeleton_icon_2_pressed() -> void:
	icon_buttons_label.text = "Increase the chance to spawn a skeleton on death"


func _on_skeleton_icon_3_pressed() -> void:
	icon_buttons_label.text = "Increase skeleton health"


func _on_skeleton_icon_4_pressed() -> void:
	icon_buttons_label.text = "Increase skeleton damage"


func _on_skeleton_icon_5_pressed() -> void:
	icon_buttons_label.text = "Skeleotons have a chance to drop xp on death"


func _on_skeleton_hand_icon_1_pressed() -> void:
	icon_buttons_label.text = "Skeleton hands will spwn and drag your enemies"


func _on_skeleton_hand_icon_2_pressed() -> void:
	icon_buttons_label.text = "More hands spawn and drag enemies"


func _on_skeleton_hand_icon_3_pressed() -> void:
	icon_buttons_label.text = "Skeleton hands spawn faster"

func _on_skeleton_hand_icon_4_pressed() -> void:
	icon_buttons_label.text = "After dragging the enemy, It will spawn a skeleton"


func _on_skeleton_hand_icon_5_pressed() -> void:
	icon_buttons_label.text = "Skeleton hands leave behind tombstones"


func _on_bone_wall_icon_1_pressed() -> void:
	icon_buttons_label.text = "Summon a bone wall to knockback enemies"


func _on_bone_wall_icon_2_pressed() -> void:
	icon_buttons_label.text = "Summon an extra wall in front of the player"


func _on_bone_wall_icon_3_pressed() -> void:
	icon_buttons_label.text = "Summon an extra wall behind the player"


func _on_bone_wall_icon_4_pressed() -> void:
	icon_buttons_label.text = "Increase wall damage and knockback"


func _on_bone_wall_icon_5_pressed() -> void:
	icon_buttons_label.text = "Walls leave behind tombstones"


func _on_random_upgrade_icon_1_pressed() -> void:
	icon_buttons_label.text = "Add fire damage to your basic attack"


func _on_random_upgrade_icon_2_pressed() -> void:
	icon_buttons_label.text = "Spawn fire pillars peridodically"


func _on_random_upgrade_icon_3_pressed() -> void:
	icon_buttons_label.text = "Spawn tombstones around the player"


func _on_random_upgrade_icon_4_pressed() -> void:
	icon_buttons_label.text = "Spawn xp orbs around the player"


func _on_random_upgrade_icon_5_pressed() -> void:
	icon_buttons_label.text = "Heal the player once every 2 minutes"


func _on_random_upgrade_icon_6_pressed() -> void:
	icon_buttons_label.text = "Player has a chance to dodge attacks"


func _on_random_upgrade_icon_7_pressed() -> void:
	icon_buttons_label.text = "Increase xp collection radius"


func _on_random_upgrade_icon_8_pressed() -> void:
	icon_buttons_label.text = "Increase player move speed"


func _on_demon_heal_icon_1_pressed() -> void:
	icon_buttons_label.text = "Heal 1 healthpoint and level up"


func _on_demon_heal_icon_2_pressed() -> void:
	icon_buttons_label.text = "Enemies have a small chance to drop health orb"


func _on_wizard_upgrade_icon_1_pressed() -> void:
	icon_buttons_label.text = "Increase basic damage"


func _on_wizard_upgrade_icon_2_pressed() -> void:
	icon_buttons_label.text = "Increase the number of fire ticks"


func _on_wizard_upgrade_icon_3_pressed() -> void:
	icon_buttons_label.text = "Increase necromancy power"


func _on_wizard_upgrade_icon_4_pressed() -> void:
	icon_buttons_label.text = "Heal one heart every minute"


func _on_question_mark_icon_pressed() -> void:
	icon_buttons_label.text = "More upgrades coming soon!"
