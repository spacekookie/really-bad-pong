extends Node2D

var screen_size
var up_bound
var down_bound

var pad_size
var direction = Vector2(0.0, 0.0)

const PAD_SPEED = 200
const UPPER_PAD_SPEED = 128
const INITIAL_BALL_SPEED = 150
var ball_speed = INITIAL_BALL_SPEED

## Setup the game world in a way where we can just assume some stuff
##
## This includes: paddle bounds, paddle sizes, screen size, initial ball direction, etc
func _ready():
	screen_size = get_viewport_rect().size
	up_bound = -(screen_size.y / 2)
	down_bound = screen_size.y / 2
	pad_size = get_node("left").get_texture().get_size()
	
	randomize()
	start_game()
	set_process(true)


func _process(delta):
	update_paddle_positions(delta)
	update_ball_position(delta)
	handle_collisions(delta)
	handle_bounces()
	handle_gameover()


# Initialises everything for the game to start
func start_game():
	get_node("left").set_meta("speed", 0)
	get_node("right").set_meta("speed", 0)
	get_node("ball").set_pos(Vector2(0, 0))
	if((randi() % 11) % 2 == 0): direction = Vector2(INITIAL_BALL_SPEED, 0.0);
	else: 						 direction = Vector2(-INITIAL_BALL_SPEED, 0.0);


# Handle all possible position changes for paddles
func update_paddle_positions(delta):
	var ml1  = handle_input(get_node("left"), "left_move_up", -1, delta)
	var ml2 = handle_input(get_node("left"), "left_move_down", 1, delta)
	
	if(not ml1 and not ml2):
		var speed = get_node("left").get_meta("speed")
		if(speed > 0): speed -= 1
		elif(speed < 0): speed += 1
		get_node("left").set_meta("speed", speed)
	
	var mr1 = handle_input(get_node("right"), "right_move_up", -1, delta)
	var mr2 = handle_input(get_node("right"), "right_move_down", 1, delta)
	
	if(not ml1 and not ml2):
		var speed = get_node("right").get_meta("speed")
		if(speed > 0): speed -= 1
		elif(speed < 0): speed += 1
		get_node("right").set_meta("speed", speed)


# A simple ball update function
func update_ball_position(delta):
	var pos = get_node("ball").get_pos()
	pos += direction * delta
	
	get_node("ball").set_pos(pos)


# Handle input and apply it to a position of a node (with delta)
func handle_input(node, handle, direction, delta):
	var pos = node.get_pos()
	var state = Input.is_action_pressed(handle)
	var moved = false
	
	var change = direction * delta * PAD_SPEED
	if(state):
		
		# TODO: This maths is shit
		if(int(pos.y) + change > up_bound + (pad_size.y / 2) and int(pos.y) + change < down_bound - (pad_size.y / 2)):
			pos.y += change
			moved = true
			
			var speed = node.get_meta("speed")
			if(speed == 0):
				node.set_meta("speed", direction)
			else:
				if(direction < 0 and speed > 0 or direction > 0 and speed < 0):
					speed = 0
				else:
					speed += direction * 4
					if(speed > UPPER_PAD_SPEED):
						speed = UPPER_PAD_SPEED
					elif (speed < -UPPER_PAD_SPEED):
						speed = -UPPER_PAD_SPEED
				node.set_meta("speed", speed)
	node.set_pos(pos)
	return moved


# A function that handles collitions on paddles
func handle_collisions(delta):
	left_collision(get_node("left"), get_node("ball"))
	right_collision(get_node("right"), get_node("ball"))


func right_collision(pad, ball):
	var pp = pad.get_pos() + Vector2(600, 200)
	var bp = ball.get_pos() + Vector2(320, 200)
	
	var pmx = pad_size.x / 2
	var pmy = pad_size.y / 2
	
	if(pp.y - pmy < bp.y and pp.y + pmy > bp.y and pp.x - pmx < bp.x and pp.x + pmx > bp.x):
		var x = ball_speed * cos(direction.angle())
		var y = ball_speed * -sin(direction.angle()) + pad.get_meta("speed")
		direction = Vector2(x, y)


func left_collision(pad, ball):
	
	var pp = pad.get_pos() + Vector2(40, 200)
	var bp = ball.get_pos() + Vector2(320, 200)
	
	var pmx = pad_size.x / 2
	var pmy = pad_size.y / 2
	
	if(pp.y - pmy < bp.y and pp.y + pmy > bp.y and pp.x + pmx > bp.x and pp.x - pmx < bp.x):
		var x = ball_speed * cos(direction.angle())
		var y = ball_speed * -sin(direction.angle()) + pad.get_meta("speed")
		direction = Vector2(x, y)


func handle_bounces():
	pass


func bounce(axis, node):
	pass


# This should probably tally up points :P
func handle_gameover():
	var bp = get_node("ball").get_pos() + Vector2(320, 200) # FIXME: Absolute position
	if(bp.x < 0 or bp.x > screen_size.x):
		start_game()


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
