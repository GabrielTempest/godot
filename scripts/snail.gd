extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite2D

@onready var animation_tree : AnimationTree = $AnimationTree

@export var starting_move_direction : Vector2 = Vector2.RIGHT
@export var movement_speed : float = 300.0
@export var hit_state : State

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = starting_move_direction
var is_moving_right = false

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	if is_moving_right && state_machine.check_if_can_move():
		velocity.x = -(direction.x * movement_speed)
	
	elif direction && state_machine.check_if_can_move():
		velocity.x = direction.x * movement_speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		
	update_animation_parameters()
	update_facing_direction()
	detect_turn_around()
	move_and_slide()
	
	
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)
	
func update_facing_direction():
	#Flip the sprite
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x
