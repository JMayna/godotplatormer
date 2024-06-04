extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

var standing_cshape = preload("res://Resources/Player_standing_cshape.tres")
var crouching_cshape = preload("res://Resources/player_crouching_cshape.tres")
@onready var cshape= $CollisionShape2D

#jump count
var jump_count = 0
var max_jumps = 2


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#gets input direction: -1, 0 , 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip Sprite
	if direction > 0:
			animated_sprite.flip_h = false
	elif direction < 0: 
			animated_sprite.flip_h = true
			
	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
			cshape.shape = standing_cshape
		else:
			animated_sprite.play("walk")
			cshape.shape = standing_cshape
	if is_on_floor():
		if Input.is_action_pressed("crouch"):
			animated_sprite.play("crouch")
			cshape.shape = crouching_cshape
	#apply movement 
	if direction:
		velocity.x = direction * SPEED
		
		
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
