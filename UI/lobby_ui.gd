extends CanvasLayer

@onready var texture_button: TextureButton = $MarginContainer/VBoxContainer/TextureButton
@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var credits_button: TextureButton = $CreditsButton
@onready var quit_button: TextureButton = $QuitButton
@onready var transition: CanvasLayer = $Transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
#func _on_button_pressed() -> void:

	


func _on_texture_button_pressed() -> void:
	transition.show()
	label.hide()
	credits_button.disabled = true
	texture_button.disabled = true
	texture_button.release_focus()
	texture_button.hide()
	credits_button.release_focus()
	credits_button.hide()
	quit_button.hide()
	#get_tree().change_scene_to_file("res://Worlds/world_1.tscn")
	transition.start_transition()


func _on_go_to_lobby_button_pressed() -> void:
	transition.show()
	label.hide()
	credits_button.disabled = true
	texture_button.disabled = true
	texture_button.release_focus()
	texture_button.hide()
	credits_button.release_focus()
	credits_button.hide()
	quit_button.hide()
	transition.transition_to_scene("res://Worlds/credits_scene.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
