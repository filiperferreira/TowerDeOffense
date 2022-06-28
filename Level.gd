extends Node2D

const ROAD_COLOR = Color(0.8,0.8,0.8)
const ROAD_WIDTH = 16.0
const ROAD_OUTLINE_COLOR = Color(0,0,0)
const ROAD_OUTLINE_WIDTH = 20.0

onready var enemy_spawner = $EnemySpawner
onready var player_spawner = $PlayerSpawner
onready var enemies = $Enemies
onready var path_points = $PathPoints
onready var towers = $Towers
onready var path_area = $PathArea

onready var path = []

func _draw():
	for i in path.size() - 1:
		draw_line(path[i], path[i+1], ROAD_OUTLINE_COLOR, ROAD_OUTLINE_WIDTH)
		draw_line(path[i], path[i+1], ROAD_COLOR, ROAD_WIDTH)

func _ready():
	build_path()

func buy_tower(tower):
	if tower.can_be_placed():
		var placed_tower = tower.duplicate()
		placed_tower.place()
		towers.add_child(placed_tower)

func calculate_road_collider(point_1, point_2):
	var x_distance = point_1.x - point_2.x
	var y_distance = point_1.y - point_2.y
	var length = sqrt(pow(y_distance, 2) + pow(x_distance, 2))
	var shape_rotation = atan(y_distance / x_distance)
	var shape_position = (point_1 + point_2) / 2
	
	var path_collider = CollisionShape2D.new()
	path_collider.position = shape_position
	path_collider.shape = RectangleShape2D.new()
	path_collider.shape.extents = Vector2(length/2, ROAD_OUTLINE_WIDTH/2)
	path_collider.rotation_degrees = rad2deg(shape_rotation)
	
	return path_collider

func build_path():
	path.push_back(player_spawner.position)
	for point in path_points.get_children():
		path.push_back(point.position)
	path.push_back(enemy_spawner.position)
	update()
	for i in path.size() - 1:
		var path_collider = calculate_road_collider(path[i], path[i+1])
		path_area.add_child(path_collider)

func spawn_enemy(enemy):
	enemy.set_target_position(path[1])
	enemy.connect("died", self, "kill")
	enemy.connect("target_reached", self, "update_target")
	enemies.add_child(enemy)

func kill(enemy):
	enemies.remove_child(enemy)
	enemy.call_deferred("queue_free")

func update_target(enemy):
	enemy.set_target_position(path[enemy.get_targets_reached() + 1])
