extends AnimatedSprite


func _ready():
	connect("animation_finished",self,"_on_AnimatedSprite_animation_finished")
	frame=0
	play("Grassanimate")



func _on_AnimatedSprite_animation_finished():
	queue_free()
