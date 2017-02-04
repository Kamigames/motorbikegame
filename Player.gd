
extends KinematicBody2D

var force = Vector2(0,0)
var MAX_SPEED = 90
var speed_increment = 20
var stop_increment = 30
var grav = 45
var max_fall_speed = 300
var jump_height = 180
var ground_touch = false
var jump_last_press = false
var jump_released = true
var jump_frames = 0
var jump_increase_flag = false
var sprite
var new_animation = "idle"
var current_animation = "idle"
var attack_hitbox
var can_attack = true
var last_attack = false
var attack_held_down = false
var is_in_arial_attack = false
var stopped = true
var can_increase_jump = true

func _ready():
	set_fixed_process(true)
	sprite = get_node("Sprite")
	attack_hitbox = get_node("Sprite/Hurtbox/CollisionShape2D")
	attack_hitbox.set_pos(Vector2(-60000,-60000))
	

func _fixed_process(delta):
	force.y += grav
	if( force.y >= max_fall_speed):
		force.y = max_fall_speed
		
	var jump = Input.is_action_pressed("jump")
	var attack = Input.is_action_pressed("attack")
	
	if(attack and can_attack and !attack_held_down):
		last_attack = attack
		if(!ground_touch):
			is_in_arial_attack = true
		can_attack = false
		attack_held_down = true
		get_node("Attack_cooldown").start()
		get_node("AnimationPlayer").play("attack_ground")
	
	if(Input.is_action_pressed("left")):
		force.x -= speed_increment
		if(force.x <= -MAX_SPEED):
			force.x = -MAX_SPEED
		sprite.set_scale(Vector2(-1,1))
		new_animation = "walking"
		stopped = false
	
	elif(Input.is_action_pressed("right")):
		force.x += speed_increment
		if(force.x >= MAX_SPEED):
			force.x = MAX_SPEED
		sprite.set_scale(Vector2(1,1))
		new_animation = "walking"
		stopped = false
	
	else :
		stopped = true
		new_animation = "idle"
		
	if(jump and ground_touch and jump_released ):
		get_node("SamplePlayer2D").play("cuteT_clean",2)
		force.y = -jump_height
		jump_last_press = jump
		ground_touch = false
		can_increase_jump = true
	
	
	if(jump and !jump_released and can_increase_jump ):
		jump_frames = jump_frames+1
		force.y -= grav+10
		if(jump_frames > 9):
			can_increase_jump = false

		
	if(jump_last_press != jump): 
		jump_released = true
	else:
		jump_released = false

	
	if(is_in_arial_attack):
		
		force.y -= 5
	
	if(last_attack != attack):
		attack_held_down = false
	
	if(stopped):
		if(ground_touch):
			if(force.x > 0):
				force.x -= stop_increment
			elif(force.x < 0):
				force.x += stop_increment
			else:
				force.x = 0
		else:
			force.x = 0
	#force.x = int(force.x)
	#force.y = int(force.y)
	var motion = force*delta
	
	
	
	if(is_colliding()):
		var n = get_collision_normal()
		if(n.y < 0):
			ground_touch = true
			jump_increase_flag = true
			jump_frames = 0
			
		elif(n.y>0):
			force.y = 0
		n = n.slide(motion)
		move(n)
	else:
		ground_touch = false
	move(motion)
	
	
	if( new_animation != current_animation):
		current_animation = new_animation
		get_node("AnimationPlayer").play(new_animation)


func _on_Attack_cooldown_timeout():
	can_attack = true
	is_in_arial_attack = false
	attack_hitbox.set_pos(Vector2(-60000,-60000))

func _on_Area2D_body_enter(body):
	print(str(body))
	if(body.get_type() == "TileMap"):
		pass
	else:
		var val = get_global_pos() - body.get_global_pos()
	
		val *= -1
		body._on_hit(val)

func _on_Label_resized():
	pass


func _on_Timer_timeout():
	pass
