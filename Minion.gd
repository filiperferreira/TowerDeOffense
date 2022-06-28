extends Node2D

const MINION_POSITION = Vector2(0,0)
const MINION_SIZE = 5.0
const MINON_PLAYER_COLOR = Color(0,0,1)
const MINON_ENEMY_COLOR = Color(1,0,0)
const MINON_OUTLINE_SIZE = 7.0
const MINION_OUTLINE_COLOR = Color(0,0,0)

var minion_owner = "unknown"
func set_minion_owner(value):
	minion_owner = value
	update()

onready var health_bar = $HealthBar
func setup_health_bar():
	health_bar.min_value = 0
	health_bar.max_value = health
	health_bar.value = health
func health_bar_take_damage(value):
	health_bar.value -= value
	if !health_bar.is_visible():
		health_bar.set_visible(true)

var speed = 100.0
var target_position
func set_target_position(new_target_position):
	target_position = new_target_position

var targets_reached = 0
func get_targets_reached():
	return targets_reached

var targeted_by_list = []
func targeted_by(bullet):
	targeted_by_list.push_back(bullet)
func remove_targeted_by(bullet):
	targeted_by_list.erase(bullet)

var incoming_damage = 0
func get_incoming_damage():
	return incoming_damage
func add_incoming_damage(value):
	incoming_damage += value

var health = 10
func get_health():
	return health
func take_damage(value):
	health -= value
	health_bar_take_damage(value)
	add_incoming_damage(-value)
	if health <= 0:
		kill()

func _draw():
	draw_circle(MINION_POSITION, MINON_OUTLINE_SIZE, MINION_OUTLINE_COLOR)
	if minion_owner == "player":
		draw_circle(MINION_POSITION, MINION_SIZE, MINON_PLAYER_COLOR)
	else:
		draw_circle(MINION_POSITION, MINION_SIZE, MINON_ENEMY_COLOR)

signal target_reached
func _process(delta):
	position += (target_position - position).normalized() * speed * delta
	if position.round() == target_position:
		targets_reached += 1
		emit_signal("target_reached", self)

func kill():
	for bullet in targeted_by_list:
		bullet.queue_free()
	queue_free()

func _on_Area_area_entered(area):
	if area.identify() == "enemy_spawner":
		kill()
