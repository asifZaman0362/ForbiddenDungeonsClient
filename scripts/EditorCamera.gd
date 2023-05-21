extends Node3D

@export var sensitivity: float = 0.1
@export var min_y: float = -89
@export var max_y: float = -10
@export var min_zoom: float = 5
@export var max_zoom: float = 20
@export var zoom_speed: float = 1
@export var move_speed: float = 0.1
@export var camera: Camera3D

var rot_x = 0
var rot_y = 0
var zoom_level = 0
var target_position: Vector3 = Vector3(0, 0, 0)
var ray_requested: bool = false

var rotating: bool = false

var from: Vector3
var to: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom_level = camera.position.z
	pass # Replace with function body.
	
func zoom(factor):
	zoom_level = clamp(zoom_level + factor * zoom_speed, min_zoom, max_zoom)

func _unhandled_input(event):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("ZoomIn"):
		zoom(-1)
	elif Input.is_action_pressed("ZoomOut"):
		zoom(1)

func _physics_process(delta):
	if ray_requested:
		ray_requested = false
		var ray = PhysicsRayQueryParameters3D.create(from, to)
		var result = get_world_3d().direct_space_state.intersect_ray(ray)
		if result:
			target_position = Vector3(result.position.x, 0, result.position.z)

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotating = true
	else:
		rotating = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ray_requested = true
	if ray_requested:
		from = camera.project_ray_origin(event.position)
		to = from + camera.project_ray_normal(event.position) * 1000
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3(0, 0, 0)
	if Input.is_key_pressed(KEY_UP):
		velocity.z = -move_speed
	if Input.is_key_pressed(KEY_DOWN):
		velocity.z = move_speed
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x = -move_speed
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = move_speed
	
	if rotating:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		var x = Input.get_last_mouse_velocity().x
		var y = Input.get_last_mouse_velocity().y
		rot_x -= x * sensitivity * delta
		rot_y = clamp(rot_y - y * sensitivity * delta, min_y, max_y)
		rotation_degrees.x = lerp(rotation_degrees.x, rot_y, abs(rotation_degrees.x - rot_y) * delta)
		rotation_degrees.y = lerp(rotation_degrees.y, rot_x, abs(rotation_degrees.y - rot_x) * delta)

	if camera != null:
		camera.look_at(position)
	position = position.move_toward(target_position, target_position.distance_to(position) * delta)
	var dp = velocity.rotated(Vector3.UP, deg_to_rad(rotation_degrees.y))
	print_debug(dp)
	target_position += dp
	camera.position.z = lerp(camera.position.z, zoom_level, abs(camera.position.z - zoom_level) * delta)
