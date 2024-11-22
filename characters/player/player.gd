extends CharacterBody3D


const SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5

@export var movement: PlayerMovementData

@export_range(5,10,0.1) var CROUCH_SPEED: float = 7.0
@export var MOUSE_SENSITIVITY: float = 0.5
@export var TILT_LOWER_LIMIT:= deg_to_rad(-90)
@export var TILT_UPPER_LIMIT:= deg_to_rad(90)
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIM: AnimationPlayer
@export var OVERHEAD_SHAPE_CAST: ShapeCast3D

@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

var input_dir
var direction

var dash: bool = false
var can_move: bool = true

var _speed: float = SPEED

var _mouse_rotation: Vector3
var _mouse_input : bool = false
var _rotation_input: float
var _tilt_input: float

var _player_rotation: Vector3
var _camera_rotation: Vector3

var _is_crouching: bool = false


func toggle_crouch():
	if _is_crouching and OVERHEAD_SHAPE_CAST.is_colliding() == false:
		ANIM.play("crouch",-1,-CROUCH_SPEED,true)
	elif !_is_crouching:
		ANIM.play("crouch",-1,CROUCH_SPEED)
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if event.is_action_pressed("crouch"):
		toggle_crouch()

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
		#print(Vector2(_rotation_input , _tilt_input))


func _update_camera(delta):
	_mouse_rotation.x += _tilt_input*delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT,TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0,_mouse_rotation.y,0)
	_camera_rotation = Vector3(_mouse_rotation.x,0,0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)

	_tilt_input = 0
	_rotation_input = 0


func _ready() -> void:
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	OVERHEAD_SHAPE_CAST.add_exception($".")


func _physics_process(delta: float) -> void:
	
	Global.debug.add_property("Movement Rotation",_mouse_rotation, 2)
	
	_update_camera(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace move actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and can_move:
		velocity.x = lerp(velocity.x, direction.x * _speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * _speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		_is_crouching=!_is_crouching


func _on_dash_state_dashgo(direction) -> void:
	velocity.x = direction.x * _speed
	velocity.z = direction.z * _speed
