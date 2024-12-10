class_name PlayerStateMachine

extends Node

@export var current_state: State

var states: Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_state_transition)
		else:
			push_warning("Child " + child.name + " is incompatible")
	current_state.enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.update(delta)
	Global.debug.add_property("State", current_state.name,1)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func on_state_transition(new_state_name: String):
	var new_state = states.get(new_state_name)
	
	if new_state:
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
	else:
		push_warning("State: " + new_state_name + " does not exist")
