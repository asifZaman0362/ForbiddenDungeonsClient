extends Control

@export var manager: WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _spawn_object(extra_arg_0):
	manager.call("spawn_object", extra_arg_0)
	pass # Replace with function body.
