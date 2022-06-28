extends Node2D

const BULLET = preload("res://Bullet.tscn")

const TOWER_SIZE = Vector2(25,25)
const TOWER_POS = TOWER_SIZE/2 - TOWER_SIZE
const TOWER_UNPLACED_COLOR = Color(1,1,1,0.5)
const TOWER_PLACED_COLOR = Color(1,1,1)
const TOWER_OUTLINE_SIZE = Vector2(29,29)
const TOWER_OUTLINE_POS = TOWER_OUTLINE_SIZE/2 - TOWER_OUTLINE_SIZE
const TOWER_OUTLINE_UNPLACED_COLOR = Color(0,0,0,0.5)
const TOWER_OUTLINE_PLACED_COLOR = Color(0,0,0)
const TOWER_UNPLACEABLE_COLOR = Color(1,0,0,0.5)
const RANGE_OUTLINE_COLOR = Color(1,0.9,0.9,0.5)

var intersect = 0
func add_intersect(value):
	intersect += value
func can_be_placed():
	if intersect == 0:
		return true
	return false

var placed = false
func place():
	placed = true

var attack_range = 100.0
var enemies_in_range = []
var damage = 5

func _ready():
	$Range/CollisionShape2D.shape.radius = attack_range

func _draw():
	if placed:
		draw_rect(Rect2(TOWER_OUTLINE_POS, TOWER_OUTLINE_SIZE), TOWER_OUTLINE_PLACED_COLOR)
		draw_rect(Rect2(TOWER_POS, TOWER_SIZE), TOWER_PLACED_COLOR)
	else:
		draw_circle(Vector2(0,0), attack_range, RANGE_OUTLINE_COLOR)
		draw_rect(Rect2(TOWER_OUTLINE_POS, TOWER_OUTLINE_SIZE), TOWER_OUTLINE_UNPLACED_COLOR)
		draw_rect(Rect2(TOWER_POS, TOWER_SIZE), TOWER_UNPLACED_COLOR)
		if intersect > 0:
			draw_rect(Rect2(TOWER_OUTLINE_POS, TOWER_OUTLINE_SIZE), TOWER_UNPLACEABLE_COLOR)

func _process(_delta):
	if $ShootTimer.is_stopped() and placed:
		$ShootTimer.start()

func _on_Area_area_entered(area):
	if area.identify() != "range":
		add_intersect(1)
		update()

func _on_Area_area_exited(area):
	if area.identify() != "range":
		add_intersect(-1)
		update()

func _on_Range_area_entered(area):
	if area.identify() == "enemy_minion":
		enemies_in_range.push_back(area.get_parent())

func _on_Range_area_exited(area):
	if area.identify() == "enemy_minion":
		enemies_in_range.erase(area.get_parent())

func _on_ShootTimer_timeout():
	if enemies_in_range.size() != 0:
		var bullet = BULLET.instance()
		for enemy in enemies_in_range:
			if damage <= enemy.get_health() - enemy.get_incoming_damage():
				enemy.add_incoming_damage(damage)
				enemy.targeted_by(bullet)
				bullet.set_target(enemy)
				bullet.set_damage(damage)
				add_child(bullet)
				break
