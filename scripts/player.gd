extends CharacterBody2D

class_name Player

@export var speed : float = 200.0



@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

func _ready():
	animation_tree.active = true

func frameFreeze(timeScale, duration):
		Engine.time_scale = timeScale
		await (get_tree().create_timer(duration*timeScale).timeout)
		Engine.time_scale = 0.1



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
			
	# Get the input direction: -1, 0, 1
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	

	
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	move_and_slide()
	update_animation_parameters()
	update_facing_direction()


func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)
	
		
func update_facing_direction():
	#Flip the sprite
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
		
	emit_signal("facing_direction_changed", sprite.flip_h)

	

	

	



