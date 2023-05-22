extends Node

@export var force_update: bool
@export var camera: Camera3D
@export var viewport: SubViewport

var assets = []
var processed = []
var i = 0
var isready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var props = DirAccess.open('res://props/')
	for filename in props.get_files():
		if filename.ends_with('.tscn'):
			assets.append(filename)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if i < len(assets) && isready:
		isready = false
		var assetname = assets[i]
		var asset = load('res://props/' + assetname)
		var node = asset.instantiate()
		add_child(node)
		# remove this stupid hardcoded timer
		# replace it with some better way to query the viewport and determine
		# if it is ready to produce a picture
		await get_tree().create_timer(0.1).timeout
		var image = viewport.get_texture().get_image()
		var thumbnail_path = 'res://thumbnails/' + assetname + '.png'
		print_debug('saving ' + thumbnail_path)
		image.save_png(thumbnail_path)
		remove_child(node)
		node.queue_free()
		processed.append(assetname)
		i += 1
		isready = true
	pass
