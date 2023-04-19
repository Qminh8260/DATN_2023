extends Node2D

onready var sprite=$AnimationSprite

func _on_HitBox_area_entered(area):
	get_tree().change_scene("res://Level2.tscn")
