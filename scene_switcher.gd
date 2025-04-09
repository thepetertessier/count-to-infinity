extends Node

var current_scene = null

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	
func goto_scene_from_path(path: String):
	var s = ResourceLoader.load(path)
	goto_scene(s)

func goto_scene(scene: PackedScene):
	var node = scene.instantiate()
	goto_node(node)

func goto_node(node: Node):
	_deferred_goto_node.call_deferred(node)

func _deferred_goto_node(node: Node):
	current_scene.free()

	# Instance the new scene.
	current_scene = node

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
