extends ColorRect

onready var checkpoint = $Checkpoint

func _ready():
	pass

func _on_Checkpoint_pressed():		
	var scene = ResourceLoader.load("user://save/main.scn","PackedScene",false)
	get_tree().change_scene_to(scene)

func _on_Startover_pressed():
	clear_save_data()
	get_tree().change_scene("res://block-dodge/screens/save-and-load-example.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func clear_save_data():
	var dir = Directory.new()
	if dir.open("user://save/") == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			dir.remove(str("user://save/",file_name))
			file_name = dir.get_next()
			
