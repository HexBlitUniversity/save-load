extends ColorRect

onready var checkpoint = $Checkpoint

func _ready():
	pass

func _on_Checkpoint_pressed():		
	pass

func _on_Startover_pressed():	
	get_tree().change_scene("res://block-dodge/screens/save-and-load-example.tscn")

func _on_Quit_pressed():
	get_tree().quit()


