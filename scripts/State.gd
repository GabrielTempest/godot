extends Node


# Called when the node enters the scene tree for the first time.
class_name State


@export var can_move : bool = true

var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State

signal interrupt_state(new_state: State)

func state_process(delta):
	pass

func state_input(event: InputEvent):
	pass
	
func on_enter():
	pass

func on_exit():
	pass
