extends WorldEnvironment

@export var barrel: PackedScene
@export var crate: PackedScene
@export var tree: PackedScene
@export var wall: PackedScene
@export var door: PackedScene

@export var camera: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_object(object):
	match object:
		"crate":
			var obj = crate.instantiate()
			add_child(obj)
			obj.get_node("Thing").position = camera.position
		"tree":
			var obj = tree.instantiate()
			add_child(obj)			
			obj.get_node("Thing").position = camera.position
		"barrel":
			var obj = barrel.instantiate()
			add_child(obj)			
			obj.get_node("Thing").position = camera.position
		"wall":
			var obj = wall.instantiate()
			add_child(obj)			
			obj.get_node("Thing").position = camera.position
		"door":
			var obj = door.instantiate()
			add_child(obj)
			obj.get_node("Thing").position = camera.position
	pass
