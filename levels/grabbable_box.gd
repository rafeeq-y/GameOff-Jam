extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.has_signal("interacted"):
		self.connect("interacted", Callable(self, "interacted"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func interacted(target) -> void:
	#TODO: set force direction of object to target
	print("interacted")
	print(target)
	var direction = (target - global_transform.origin)
	var force = direction * 200  # Adjust the magnitude as needed
	apply_central_force(force)
	linear_velocity *= linear_damp
	print("freezing")
	freeze = true
