class_name SprintingState

extends State

@export var anim: AnimationPlayer
@export var top_anim_speed: float = 1.0

func update(delta: float) -> void:
	set_anim_speed(Global.player.velocity.length())
	if Input.is_action_just_pressed("dash"):
		anim.pause()
		transition.emit("DashState")
	if Input.is_action_just_pressed("sprint"):
		Global.player.is_sprinting = false
		transition.emit("WalkingState")
	if Global.player.velocity.length() == 0.0:
		Global.player.is_sprinting = false
		transition.emit("IdleState")
		
func physics_update(delta: float) -> void:
	pass

func enter() -> void:
	anim.play("sprinting",0.5,1.0)
	Global.player._speed = Global.player.sprint_speed

func exit() -> void:
	pass


func set_anim_speed(spd):
	var alpha = remap(spd, 0.0,Global.player.sprint_speed,0.0,1.0)
	anim.speed_scale = lerp(0.0,top_anim_speed,alpha)
