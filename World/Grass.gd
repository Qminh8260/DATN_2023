extends Node2D

const Grasse=preload("res://Effects/Grasseffect.tscn")

func create_grass_effect():

	var grasseffect = Grasse.instance()
	get_parent().add_child(grasseffect)
	grasseffect.global_position=global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
