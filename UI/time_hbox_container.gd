extends HBoxContainer

@onready var canvas_layer: CanvasLayer = $"../../../../../../.."

@onready var minutes_label: Label = $MinutesLabel
@onready var seconds_label: Label = $SecondsLabel
@onready var dots_label: Label = $"Dots Label"
@onready var timer: Timer = $Timer

var player
var elapsed_time: int = 0
var playerDead = false
var root

func _ready():
	await get_tree().create_timer(0.5).timeout
	player = get_tree().get_first_node_in_group("Player")
	root = get_tree().current_scene
	
	#set player health
	if is_instance_valid(player):
		player.timer_stop.connect(stop_timer)  # Connect the signal
		player.timer_start.connect(start_timer)


func stop_timer():
	timer.stop()
	
func start_timer():
	timer.start()

func _on_timer_timeout():
	elapsed_time += 1  # Increase time by 1 second
	update_timer_display()

func update_timer_display():
	var minutes = elapsed_time / 60
	var seconds = elapsed_time % 60
	minutes_label.text = "%02d" % minutes  # Format as 2-digit
	seconds_label.text = "%02d" % seconds  # Format as 2-digit
	if minutes == 10 and seconds == 00:
		timer.stop()
		root.time_finished = true
		canvas_layer.show_win_ui()
	if minutes == 10:
		seconds = 00
