extends KinematicBody

var velocity = Vector3()

var _mouse_motion = Vector2()
var _selected_block = 2

var pointing = 0
var pointing_block = null

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

onready var head = $Head
onready var raycast = $Head/RayCast
onready var voxel_world = $"../voxi"
onready var crosshair = $crosshair

var head_height = 1.6
var mouse_transform = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	# Mouse movement.
	_mouse_motion.y = _mouse_motion.y
	mouse_transform = Vector3(_mouse_motion.y * -0.001, _mouse_motion.x * -0.001, 0)
	head.transform.basis = Basis(mouse_transform)

	# Block selection.
	var position = raycast.get_collision_point()
	var normal = raycast.get_collision_normal()
	#if Input.is_action_just_pressed("pick_block"):
	#	# Block picking.
	#	var block_global_position = (position - normal / 2).floor()
	#	_selected_block = voxel_world.get_block_global_position(block_global_position)
	#else:
	#	# Block prev/next keys.
	#	if Input.is_action_just_pressed("prev_block"):
	#		_selected_block -= 1
	#	if Input.is_action_just_pressed("next_block"):
	#		_selected_block += 1
	#	_selected_block = wrapi(_selected_block, 1, 30)
	# Set the appropriate texture.
	#var uv = Chunk.calculate_block_uvs(_selected_block)
	
	movement(_delta)

	# Block breaking/placing.
	if raycast.is_colliding():
		# This is needed for debugging and block interaction
		pointing = position
		pointing_block = voxel_world.mod_loader.getBlock(voxel_world.get_block_global_position((position - normal / 2).floor()))
		
		var breaking = Input.is_action_just_pressed("break")
		var placing = Input.is_action_just_pressed("place")
		
		# Either both buttons were pressed or neither are, so stop.
		if breaking == placing:
			return
		
		if breaking:
			var block_global_position = (position - normal / 2).floor()
			voxel_world.set_block_global_position(block_global_position, 0)
		elif placing:
			var block_global_position = (position + normal / 2).floor()
			voxel_world.set_block_global_position(block_global_position, _selected_block)
	else:
		pointing = position
		pointing_block = null

func movement(delta):
	# Crouching.
	var crouching = Input.is_action_pressed("crouch")
	var running = Input.is_action_pressed("run")
	if crouching:
		head_height = 1.2
	else:
		head_height = 1.6
	head.transform.origin.y = head_height - (head.transform.origin.y - head_height) * 0.05

	# Keyboard movement.
	var movement_vec2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement = Basis(mouse_transform * Vector3(0, 1, 0)).xform(Vector3(movement_vec2.x, 0, movement_vec2.y))
	if !crouching:
		movement *= 5
	if running:
		movement *= 1.5

	# Gravity.
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	# Jumping.
	if is_on_floor() and Input.is_action_pressed("jump") and velocity.y <= 0:
		velocity.y = 7

	#warning-ignore:return_value_discarded
	velocity = move_and_slide(Vector3(movement.x, velocity.y, movement.z), Vector3.UP)


func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_mouse_motion += event.relative


func chunk_pos():
	return (transform.origin / Chunk.CHUNK_SIZE).floor()
