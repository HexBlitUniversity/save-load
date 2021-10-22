extends Node2D

onready var player = $player
onready var enemy_container_top = $enemyContainerTop
onready var enemy_container_left = $enemyContainerLeft

onready var timer = $Timer
onready var progression = $progressionTimer
onready var progress = $player/ProgressBar
onready var enemy_long = load("res://block-dodge/actors/enemyLong.tscn")
onready var enemy_rect = load("res://block-dodge/actors/enemyRect.tscn") 

var rng = RandomNumberGenerator.new() 	

var SAVE_DIR = "user://save/"
var SAVE_FILE = "game_data.save"

func _ready():
	load_save()
	
	timer.start()
	progression.start()
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused

# Signals 
func _on_Timer_timeout():
	spawn_entity()	

func _on_progressionTimer_timeout():
	player.increase_progress()	
	save()	
	if player.get_progress() >= 100:
		get_tree().change_scene("res://block-dodge/screens/GameOver.tscn")
	
func _on_player_playerDied():
	get_tree().change_scene("res://block-dodge/screens/GameOver.tscn")

# Custom Methods 
func spawn_entity():
	if progress.value < 20:
		spawn_entity_top()
	elif(progress.value < 45):
		spawn_random_entity()
	else:
		spawn_random_entity()
		spawn_flying_rect()

 
func spawn_random_entity():
		rng.randomize()
		var rand_entity = rng.randi_range(1,2)
		match rand_entity:
			1: 
				spawn_entity_top()
			2:
				spawn_entity_left()


func spawn_entity_top():
	var entity = null	
	entity = enemy_long.instance()
	entity.set_name("EnemyLongRed ")
	var position = Vector2(rng.randi_range(-650,-100),enemy_container_top.position.y)
	entity.position = position	
	enemy_container_top.add_child(entity)
	entity.rotate_degrees_and_color(Vector2.DOWN, 1,0, 0)
	
	
func spawn_entity_left():	
	var entity  = null	
	entity = enemy_long.instance()
	entity.set_name("EnemyLongBlue")
	var position = Vector2(enemy_container_left.position.y,rng.randi_range(80,875))
	entity.position = position	
	enemy_container_left.add_child(entity)	
	entity.rotate_degrees_and_color(Vector2.RIGHT, 0,0, 1)
	
	
func spawn_flying_rect():
	var entity = null	
	entity = enemy_rect.instance()
	entity.position = enemy_container_top.position
	enemy_container_top.add_child(entity)
	entity.look_at(player.position)
	entity.set_trajectory(player.get("global_position"))
	
func save():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir(SAVE_DIR)
	
	var save_game = File.new()
	save_game.open(str(SAVE_DIR,SAVE_FILE),File.WRITE)
	var save_data = {} 
	var find_saveable_nodes = get_tree().get_nodes_in_group("saveable")
	for saveable in find_saveable_nodes:
		if !saveable.has_method("save"):
			print("Saveable node is missing a save() function... skipped.")
			continue
			
		saveable.set_owner(self)
		save_data[saveable.name] = saveable.call("save")
			
	var data_string = var2str(save_data)
	save_game.store_string(data_string)
	save_game.close()
			
	var saveScene = PackedScene.new()
	if saveScene.pack(self) == OK:
		ResourceSaver.save("user://save/main.scn",saveScene)
	
func load_save():
	var save_game = File.new()
	if !save_game.file_exists(str(SAVE_DIR,SAVE_FILE)):
		print("No save file detected.")
		return

	save_game.open(str(SAVE_DIR,SAVE_FILE),File.READ)
	var data_string = save_game.get_as_text()
	var save_data : Dictionary = str2var(data_string)
	
	if save_data.has("player"):
		player.load_save(save_data["player"])		
		save_data.erase("player")
	
	for node_name in save_data.keys():		
		var entity = find_node(node_name,true,true)
		if(entity != null): 		
			entity.load_save(save_data[node_name])
				 
	print(save_data)
	save_game.close()


