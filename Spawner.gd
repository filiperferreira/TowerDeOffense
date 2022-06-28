extends Node2D

const SPAWNER_SIZE = Vector2(50,50)
const SPAWNER_POS = SPAWNER_SIZE/2 - SPAWNER_SIZE
const SPAWNER_PLAYER_COLOR = Color(0,0,1)
const SPAWNER_ENEMY_COLOR = Color(1,0,0)
const SPAWNER_OUTLINE_SIZE = Vector2(54,54)
const SPAWNER_OUTLINE_POS = SPAWNER_OUTLINE_SIZE/2 - SPAWNER_OUTLINE_SIZE
const SPAWNER_OUTLINE_COLOR = Color(0,0,0)

onready var area = $Area
onready var towers = $Towers
onready var minions = $Minions

export var identity = "unknown"

func _ready():
	area.set_identity(identity)

func _draw():
	draw_rect(Rect2(SPAWNER_OUTLINE_POS, SPAWNER_OUTLINE_SIZE), SPAWNER_OUTLINE_COLOR)
	if identity == "player_spawner":
		draw_rect(Rect2(SPAWNER_POS, SPAWNER_SIZE), SPAWNER_PLAYER_COLOR)
	else:
		draw_rect(Rect2(SPAWNER_POS, SPAWNER_SIZE), SPAWNER_ENEMY_COLOR)

func spawn_minion(minion):
	minion.connect("target_reached", self, "update_target")
	minion.set_position(get_global_position())
	if identity == "player_spawner":
		minion.set_minion_owner("player")
	else:
		minion.set_minion_owner("enemy")
	minions.add_child(minion)

func add_tower(tower):
	var placed_tower = tower.duplicate()
	placed_tower.place()
	towers.add_child(placed_tower)
