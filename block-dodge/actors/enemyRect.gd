extends KinematicBody2D

export var speed = 850
onready var block = $ColorRect

var trajectory = Vector2.ZERO
var attack = false
var block_rotation = 0

func _physics_process(delta):
	block_rotation += 5
	if block_rotation > 360:
		block_rotation = 0
		
	block.set_rotation(deg2rad(block_rotation))
	if trajectory:
		translate(trajectory*speed*delta)

# Signals
func _on_Timer_timeout():	
	queue_free()
		
# Custom Methods 
func set_trajectory(playerPosition : Vector2):
	if !trajectory:
		trajectory = (playerPosition - global_position).normalized()

func save(): 
	return { "trajectory" : trajectory,
			 "attack" : attack,
			 "block_rotation" : block_rotation		
	}

func load_save(data):
	if not data: 
		return
	
	trajectory = data["trajectory"]
	attack = data["attack"]
	block_rotation = data["block_rotation"]
		

 
