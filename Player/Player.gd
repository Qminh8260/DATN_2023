extends KinematicBody2D

const PlayerHurtSound=preload("res://Player/PlayerHurtSound.tscn")

export var acceleration=500
export var MAX_speed=100
export var fric=500
export var roll_speed=100

enum{
	Move,
	Roll,
	Attack
}

var state=Move
var vec=Vector2.ZERO
var roll_vec=Vector2.DOWN
var starts=PlayerStats

onready var animationPlayer=$AnimationPlayer
onready var animationTree=$AnimationTree
onready var animationState=animationTree.get("parameters/playback")
onready var swordhitbox=$Positionhitbox/SwordHitbox
onready var hurtbox=$Hurtbox
onready var blinkanimation=$BlinkAnimation

func _ready():
	starts.connect("no_health",self,"queue_free")
	animationTree.active=true
	swordhitbox.knockback_vector=roll_vec

func _physics_process(delta):
	match state:
		Move:
			move_state(delta)
		Roll:
			roll_state()
		Attack:
			attack_state()

	
func move_state(delta):
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left");
	input_vector.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
	
	input_vector=input_vector.normalized()
	if(input_vector != Vector2.ZERO):
		roll_vec=input_vector
		swordhitbox.knockback_vector=input_vector
		animationTree.set("parameters/stop/blend_position", input_vector)
		animationTree.set("parameters/run/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		animationTree.set("parameters/roll/blend_position", input_vector)
		animationState.travel("run")
		vec=vec.move_toward(input_vector*MAX_speed, acceleration*delta)
	else:
		animationState.travel("stop")
		vec=vec.move_toward(Vector2.ZERO, fric*delta)
		
	move()
	
	if Input.is_action_just_pressed("ui_roll"):
		state=Roll
	
	if Input.is_action_just_pressed("ui_attack"):
		state = Attack

func attack_state():
	vec=Vector2.ZERO
	animationState.travel("attack")

func roll_state():
	vec=roll_vec*roll_speed
	animationState.travel("roll")
	move()

func move():
	vec=move_and_slide(vec) 

func roll_animation_finish():
	vec=Vector2.ZERO
	state=Move

func attack_animation_finish():
	state=Move


func _on_Hurtbox_area_entered(_area):
	starts.health-=1
	hurtbox.start_invicibility(0.5)
	hurtbox.create_hit_effect()
	var PlayerHurtSounds=PlayerHurtSound.instance()
	get_tree().current_scene.add_child(PlayerHurtSounds)
	if starts.health == 0:
		get_tree().change_scene("res://GameOver.tscn")


func _on_Hurtbox_invicibility_started():
	blinkanimation.play("Start")


func _on_Hurtbox_invicibility_ended():
	blinkanimation.play("Stop")
