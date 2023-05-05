extends KinematicBody2D

const EnemyDeath=preload("res://Effects/EnemyDeath.tscn")

export var Acceleration=300
export var Max_speed=50
export var fric=200

enum{
	Idle,
	Wander,
	Chase
}

var state = Idle
var knockback=Vector2.ZERO
var vec=Vector2.ZERO

onready var sprite=$AnimationSprite
onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone
onready var hurtbox=$Hurtbox

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,200*delta)
	knockback=move_and_slide(knockback)
	
	match state:
		Idle:
			vec=vec.move_toward(Vector2.ZERO,200*delta)
			seek_player()
		Wander:
			pass
		Chase:
			var player=playerDetectionZone.player
			if player != null:
				var direction=(player.global_position-global_position).normalized()
				vec=vec.move_toward(direction*Max_speed,Acceleration*delta)
			else:
				state=Idle
			sprite.flip_h=vec.x<0
	vec=move_and_slide(vec)

func seek_player():
	if playerDetectionZone.see_player():
		state=Chase

func _on_Hurtbox_area_entered(area):
	stats.health -=area.damage
	knockback=area.knockback_vector *110
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var DeathEffect = EnemyDeath.instance()
	get_parent().add_child(DeathEffect)
	DeathEffect.global_position=global_position
