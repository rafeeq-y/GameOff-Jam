class_name IdleState

extends State

@export var anim: AnimationPlayer

func update(delta):
	if Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		transition.emit("WalkingState")
	#if Global.player.is_sprinting and 
func enter() -> void:
	anim.pause()
