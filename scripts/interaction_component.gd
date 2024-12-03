class_name InteractionComponent

extends Node
var parent

func _ready() -> void:
	if get_parent():
		parent = get_parent()
		connect_parent()
func in_range() -> void:
	print("in range")
	
func out_of_range() -> void:
	print("out of range")
	
func interacted() -> void:
	print("interacted")
	
func throw() -> void:
	print("throw")
	
	
func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.add_user_signal("throw")
	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "out_of_range"))
	parent.connect("interacted", Callable(self, "interacted"))
	parent.connect("throw", Callable(self, "throw"))
