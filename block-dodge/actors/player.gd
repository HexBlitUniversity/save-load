extends KinematicBody2D
onready var colorRect = $ColorRect
onready var progress = $ProgressBar
export var speed = 800

export var progressValue = 0
signal playerDied 

func _ready():	
	pass

func _physics_process(delta):
	
	var position = get_local_mouse_position()	
	
	var horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	var vertical = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	translate(Vector2(horizontal*speed*delta,vertical*speed*delta))

# Signals
func _on_Area2D_area_entered(area):
	emit_signal("playerDied")
	queue_free()

# Custom Methods 
func increase_progress():
	progress.value += 1
	
func get_progress():
	return int(progress.value)
	
func save():
	return {
		"progress" : progress.value,
		"pos_x" : position.x,
		"pos_y" : position.y,
	}

func load_save(data):
	if not data:
		return
	
	progress.value = data["progress"]
	position.x = data["pos_x"]
	position.y = data["pos_y"]
