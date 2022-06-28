extends Node2D

const BULLET_RADIUS = 3.0
const BULLET_COLOR = Color(1,1,1)
const BULLET_OUTLINE_RADIUS = 5.0
const BULLET_OUTLINE_COLOR = Color(0,0,0)

var speed = 200.0
var target
func set_target(new_target):
	target = new_target

var damage = 0
func set_damage(value):
	damage = value

func _draw():
	draw_circle(Vector2(0,0), BULLET_OUTLINE_RADIUS, BULLET_OUTLINE_COLOR)
	draw_circle(Vector2(0,0), BULLET_RADIUS, BULLET_COLOR)

func _process(delta):
	if target != null:
		position += (target.get_global_position() - get_global_position()).normalized() * speed * delta
		if get_global_position().floor() == target.get_global_position().floor():
			target.remove_targeted_by(self)
			target.take_damage(damage)
			queue_free()
