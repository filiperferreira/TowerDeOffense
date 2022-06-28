extends Node2D

const SPAWNER_SIZE = Vector2(50,50)
const SPAWNER_POS = SPAWNER_SIZE/2 - SPAWNER_SIZE
const SPAWNER_COLOR = Color(1,0,0)
const SPAWNER_OUTLINE_SIZE = Vector2(54,54)
const SPAWNER_OUTLINE_POS = SPAWNER_OUTLINE_SIZE/2 - SPAWNER_OUTLINE_SIZE
const SPAWNER_OUTLINE_COLOR = Color(0,0,0)

const ENEMY = preload("res://Enemy.tscn")

func _draw():
	draw_rect(Rect2(SPAWNER_OUTLINE_POS, SPAWNER_OUTLINE_SIZE), SPAWNER_OUTLINE_COLOR)
	draw_rect(Rect2(SPAWNER_POS, SPAWNER_SIZE), SPAWNER_COLOR)

signal enemy_spawn
func spawn_enemy():
	var enemy = ENEMY.instance()
	enemy.position = get_global_position()
	emit_signal("enemy_spawn", enemy)

func _on_SpawnTimer_timeout():
	spawn_enemy()
