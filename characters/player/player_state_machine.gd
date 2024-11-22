class_name PlayerStateMachine

extends Node

@export var CURRENT_STATE: State

var states: Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_state_transition)
		else:
			push_warning("Child " + child.name + " is incompatible")
	CURRENT_STATE.enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)
	Global.debug.add_property("State", CURRENT_STATE.name,1)

func _physics_process(delta: float) -> void:
	CURRENT_STATE.physics_update(delta)


func on_state_transition(new_state_name: String):
	var new_state = states.get(new_state_name)
	
	if new_state:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE = new_state
	else:
		push_warning("State: " + new_state_name + " does not exist")
	
