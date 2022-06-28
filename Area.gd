extends Area2D

export var identity = "unknown"
func set_identity(value):
	identity = value
func identify():
	return identity

func get_parent():
	return get_owner()
