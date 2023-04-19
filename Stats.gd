extends Node

export(int) var max_health=2 setget set_max_health
var health=max_health setget set_health


signal no_health
signal change_health(value)
signal max_health_change(value)

func set_max_health(value):
	max_health=value
	self.health=min(health,max_health)
	emit_signal("max_health_change",max_health)

func set_health(value):
	health=value
	emit_signal("change_health",health)
	if health <=0:
		emit_signal("no_health")

func _ready():
	self.health=max_health
