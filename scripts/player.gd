extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var last_jump = "";

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	handle_jump(direction)
	handle_wall_grabbing()

	move_and_slide()

func handle_jump(direction):
	if Input.is_action_just_pressed("ui_accept"):
		if (is_on_floor()):
			velocity.y = JUMP_VELOCITY
			last_jump = "FLOOR"
		if (is_grabbing_wall() and last_jump=="FLOOR"):
			velocity.y = JUMP_VELOCITY
			velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED) 
			last_jump = "WALL"
			
func handle_wall_grabbing():
	if is_grabbing_wall() and not Input.is_action_just_pressed("ui_accept"):
		velocity.x = 0
		velocity.y = 0
		
func is_grabbing_wall():
	return is_on_wall_only() and Input.is_action_pressed("crouch")
