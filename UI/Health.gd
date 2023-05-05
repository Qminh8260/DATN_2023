extends Control

var heart=4 setget set_heart
var max_heart=4 setget set_max_heart

onready var heartUI=$heartUI
onready var heartUIFull=$heartUIFull

func set_heart(value):
	heart=clamp(value,0,max_heart)
	if heartUIFull!=null:
		heartUIFull.rect_size.x=heart*15
	
func set_max_heart(value):
	max_heart=max(value,1)
	self.heart=min(heart,max_heart)
	if heartUI != null:
		heartUI.rect_size.x=max_heart*15

func _ready():
	self.max_heart=PlayerStats.max_health
	self.heart=PlayerStats.health
	PlayerStats.connect("change_health",self,"set_heart")
	PlayerStats.connect("max_health_change",self,"set_max_heart")
