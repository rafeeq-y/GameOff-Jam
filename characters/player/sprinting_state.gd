class_name SprintingState

extends State

@export var ANIM: AnimationPlayer
@export var TOP_ANIM_SPEED: float = 1.0

func update(delta: float) -> void:
	set_anim_speed(Global.player.velocity.length())

func physics_update(delta: float) -> void:
	pass

func enter() -> void:
	ANIM.play("sprinting",0.5,1.0)
	Global.player._speed = Global.player.SPRINT_SPEED

func exit() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		transition.emit("WalkingState")

func set_anim_speed(spd):
	var alpha = remap(spd, 0.0,Global.player.SPRINT_SPEED,0.0,1.0)
	ANIM.speed_scale = lerp(0.0,TOP_ANIM_SPEED,alpha)
