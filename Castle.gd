extends Node2D

const CASTLE_SIZE = Vector2(70,70)
const CASTLE_POS = CASTLE_SIZE/2 - CASTLE_SIZE
const CASTLE_COLOR = Color(1,1,1)
const CASTLE_OUTLINE_SIZE = Vector2(74,74)
const CASTLE_OUTLINE_POS = CASTLE_OUTLINE_SIZE/2 - CASTLE_OUTLINE_SIZE
const CASTLE_OUTLINE_COLOR = Color(0,0,0)

func _draw():
	draw_rect(Rect2(CASTLE_OUTLINE_POS, CASTLE_OUTLINE_SIZE), CASTLE_OUTLINE_COLOR)
	draw_rect(Rect2(CASTLE_POS, CASTLE_SIZE), CASTLE_COLOR)

func _on_Area_area_entered(area):
	if area.identify() == "enemy":
		var enemy = area.get_parent()
		enemy.kill()
