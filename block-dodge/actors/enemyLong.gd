extends KinematicBody2D

onready var timer = $Timer
onready var rectOne = $ColorRect
onready var rectTwo = $ColorRect2

export var speed = 1550
var block_direction = Vector2(0,1)
var block_color : Color 
	
func _physics_process(delta):
	translate(block_direction*speed*delta)
	
# Signals
func _on_Timer_timeout():	
	queue_free()
	
# Custom Methods	
func rotate_degrees_and_color(direction :Vector2, r:int,g:int, b:int):
	rotate(Vector2.DOWN.angle_to(direction))
	block_color = Color(r,g,b,1)	
	block_direction = direction	
	
	rectOne.color = block_color
	rectTwo.color = block_color

 
