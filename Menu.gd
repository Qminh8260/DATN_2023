extends Control

var starts=PlayerStats

func _ready():
	$VBoxContainer/Startbutton.grab_focus()

func _on_Startbutton_pressed():
	starts.health = 3
	get_tree().change_scene("res://world.tscn")



func _on_Optionbutton_pressed():
	get_tree().change_scene("res://Option.tscn")


func _on_Quitbutton_pressed():
	get_tree().quit()
