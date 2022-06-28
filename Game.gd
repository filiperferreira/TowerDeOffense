extends Node2D

const TOWER = preload("res://Tower.tscn")

onready var level = $Level
onready var mode_label = $CanvasLayer/MarginContainer/ManagementMode
func mode_label_update(text):
	mode_label.set_text(text)

var state = "tower"

var tower_visual

func _ready():
	tower_to_buy()

func _process(_delta):
	if Input.is_action_just_pressed("Q"):
		state = "tower"
		mode_label_update("Tower Mode")
		tower_visual.set_visible(true)
	elif Input.is_action_just_pressed("W"):
		state = "minion"
		mode_label_update("Minion Mode")
		tower_visual.set_visible(false)
	elif state == "tower" and Input.is_action_just_pressed("click"):
		level.buy_tower(tower_visual)
	elif state == "minion" and Input.is_action_just_pressed("space"):
		level.spawn_minion()
	
	if tower_visual != null:
		tower_visual.set_position(get_global_mouse_position())

func tower_to_buy():
	tower_visual = TOWER.instance()
	tower_visual.set_position(get_global_mouse_position())
	add_child(tower_visual)
