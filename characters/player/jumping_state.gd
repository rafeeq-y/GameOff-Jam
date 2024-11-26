class_name JumpingState

extends State


func update(delta):
	if Global.player.is_on_floor():
		if Global.player.is_sprinting:
			transition.emit("SprintingState")
		else:
			transition.emit("IdleState")

func physics_update(delta):
	pass

func enter():
	print("Entered jumping state")

func exit():
	pass
