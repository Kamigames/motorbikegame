
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var motion
var speed = 3
var facing = 1
func _ready():
	set_fixed_process(true)
	

func _fixed_process(delta):
	motion = Vector2(0,0)
	var player_pos = get_parent().get_node("Player").get_global_pos()
	var drone_pos = get_global_pos()
	motion = player_pos - drone_pos - Vector2(10,0)
	motion.y += rand_range(-16,16)
	
	move(motion*delta*speed)
	
	if(motion.x < 0):
		facing = -1
	else : facing = 1
	
	get_node("Sprite").set_scale(Vector2(facing,1))
	
func _on_Timer_timeout():
	var timer = get_node("Timer")
	timer.set_wait_time(rand_range(2,5))
	timer.start()
	#get_node("SamplePlayer2D").play("cute")
	