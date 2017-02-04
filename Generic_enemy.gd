
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var was_hit = false
var attacker_pos = Vector2(0,0)
var weight = 3
var direction
var grav = 60
var force = Vector2(0,0)
func _ready():
	set_fixed_process(true)
	set_meta("Enemy",0)
	
func _fixed_process(delta):
	
	if( get_pos().x >= 120):
		force = -force 
	move(force*delta)
func _on_hit(val):
	if(!was_hit):
		attacker_pos = val
		weight = 20
		was_hit = true
		get_node("Timer").start()

func _on_Timer_timeout():
	was_hit = false