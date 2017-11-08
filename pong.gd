extends Node2D

var screen_size
var pad_size
var direction = Vector2(0.0, 0.0)

const PAD_SPEED = 250
const INITIAL_BALL_SPEED = 110
var ball_speed = INITIAL_BALL_SPEED

var left_speed = 0
var right_speed = 0

## Setup the game world in a way where we can just assume some stuff
##
## This includes: paddle bounds, paddle sizes, screen size, initial ball direction, etc
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	
	# Pick a random ball direction
	randomize()
	if((randi() % 11) % 2 == 0): direction = Vector2(INITIAL_BALL_SPEED, 0.0);
	else: 						 direction = Vector2(-INITIAL_BALL_SPEED, 0.0);
	set_process(true)


func _process(delta):
	update_paddle_position(delta)
	update_ball_position(delta)


func update_paddle_position(delta):
	pass


func update_ball_position(delta):
	var pos = get_node("ball").get_pos()
	pos += direction * delta
	get_node("ball").set_pos(pos)


func handle_input(pad, handle, direction, delta):
	var pos = get_node(pad).get_pos()
	var state = Input.is_action_pressed(handle)
	if(state): return pos + direction * delta * PAD_SPEED
	return pos


func handle_collisions(delta):
	pass


func handle_gameover():
	pass

#	var ball_pos = get_node("ball").get_pos()
#	var left_rect = Rect2(get_node("left").get_pos() - pad_size * 0.5, pad_size)
#	var right_rect = Rect2(get_node("right").get_pos() - pad_size * 0.5, pad_size)
#	
#	ball_pos += direction * ball_speed * delta
#	
#	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
#		direction.y = -direction.y
#		
#	# Flip, change direction and increase speed when touching pads
#	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
#    	direction.x = -direction.x
#	    direction.y = randf()*2.0 - 1
#	    direction = direction.normalized()
#	    ball_speed *= 1.1
#	
#	# Check gameover
#	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
#	    ball_pos = screen_size * 0.5
#	    ball_speed = INITIAL_BALL_SPEED
#	    direction = Vector2(-1, 0)
#	
#	# Move left pad
#	var left_pos = get_node("left").get_pos()
#	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
#		left_pos.y += -PAD_SPEED * delta
#		
#		if (left_speed <= 0):
#			left_speed -= 1
#		else:
#			left_speed = -1
#			
#	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
#		left_pos.y += PAD_SPEED * delta
#		
#		if (left_speed >= 0):
#			left_speed += 1
#		else:
#			left_speed = 1
#	
#	get_node("left").set_pos(left_pos)
#	
#	# Move right pad
#	var right_pos = get_node("right").get_pos()
#	if (right_pos.y > 0  and Input.is_action_pressed("right_move_up")):
#	    right_pos.y += -PAD_SPEED * delta
#	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
#	    right_pos.y += PAD_SPEED * delta
#	get_node("right").set_pos(right_pos)
#	
#	# Reflect the ball if it hits any of the padles
#	
#	print(left_speed)
#
#	get_node("ball").set_pos(ball_pos);
