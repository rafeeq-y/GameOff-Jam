class_name WalkingState

extends State

@export var anim: AnimationPlayer
@export var TOP_ANIM_SPEED: float = 2.2


func update(delta):
	set_anim_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdleState")
	if Input.is_action_just_pressed("dash"):
		anim.pause()
		transition.emit("DashState")
	if Input.is_action_just_pressed("sprint"):
		Global.player.is_sprinting = true
		transition.emit("SprintingState")

func enter() -> void:
	Global.player._speed = Global.player.default_speed
	anim.play("walking",-1,1)



func set_anim_speed(spd):
	var alpha = remap(spd, 0.0, Global.player._speed, 0.0, 1.0)
	anim.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
