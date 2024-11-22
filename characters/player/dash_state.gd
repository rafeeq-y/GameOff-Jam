class_name DashState

extends State

signal dashgo


@onready var dash_timer: Timer = $DashTimer

@export var DASH_SPEED: float = 20
var direction

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func enter() -> void:
	print("Enter Dash State")
	dash_timer.start()
	Global.player._speed = DASH_SPEED
	Global.player.can_move = false
	dashgo.emit(Global.player.direction)
	
func exit() -> void:
	print("Exit Dash State")
	Global.player.can_move = true

func _on_dash_timer_timeout() -> void:
	transition.emit("IdleState")
