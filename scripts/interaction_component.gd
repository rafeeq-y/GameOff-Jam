class_name InteractionComponent

extends Node


var parent
var highlight_material = preload("res://materials/interactable_highlight.tres")

func _ready() -> void:
	if get_parent():
		parent = get_parent()
		connect_parent()
func in_range() -> void:
	get_mesh().material_overlay = highlight_material
	
func out_of_range() -> void:
	get_mesh().material_overlay = null
	
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

func get_mesh() -> MeshInstance3D:
	for child in parent.get_children():
		if child is MeshInstance3D:
			return child
	return
