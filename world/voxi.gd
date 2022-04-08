extends Node

const CHUNK_MID = Vector3(0.5, 0.5, 0.5) * Chunk.SIZE
const CHUNK_END_SIZE = Chunk.SIZE - 1


var render_distance = 2
var delete_distance = render_distance + 2
var render_layer = 0 # This let's us render the circles of chunks around the player

var generate = true
var removing = false

var chunks = {} # store our chunks here

onready var player = $"../Player"
onready var mod_loader =  BlockStore.new()

# noise
var noise = TerrainDog.genNoise()

func _ready():
	print("[VoxiWorld] --> World ready. Asking Modloader if there's anything to load...")
	var image = ModLoader.gen_atlas(
		[
			"res://assets/blocks/grass/top.png",
			"res://assets/blocks/stone/default.png"
		]
	)
	image.save_png("res://assets/atlas.png")
	#add_child(image)
	# Assume ModLoader injected the data into our Blocks and Entities

func _physics_process(_delta):
	var player_chunk = (player.transform.origin / Chunk.SIZE).round()
	
	if removing:
		# Do something here
		generate = true
		return
	
	if not generate:
		return
	
	player_chunk.y += round(clamp(player.velocity.y, -render_distance / 4, render_distance / 4))
	
	for x in range(player_chunk.x - render_layer, player_chunk.x + render_layer):
		for y in range(player_chunk.y - render_layer, player_chunk.y + render_layer):
			for z in range(player_chunk.z - render_layer, player_chunk.z + render_layer):
				var chunk_pos = Vector3(x, y, z)
				if player_chunk.distance_to(chunk_pos) > render_distance:
					continue
				if chunks.has(chunk_pos):
					continue
				var chunk = Chunk.new(chunk_pos)
				chunks[chunk_pos] = chunk
				add_child(chunk)
				return
	if render_layer < render_distance:
		render_layer += 1
	else:
		generate = false

func set_block_global_position(block_global_position, block_id):
	var chunk_position = (block_global_position / Chunk.SIZE).floor()
	var chunk = chunks[chunk_position]
	var sub_position = block_global_position.posmod(Chunk.SIZE)
	if block_id == 0:
		chunk.data.erase(sub_position)
	else:
		chunk.data[sub_position] = block_id
	chunk.regenerate()

	# We also might need to regenerate some neighboring chunks.
	#if Chunk.is_block_transparent(block_id):
	#	if sub_position.x == 0:
	#		chunks[chunk_position + Vector3.LEFT].regenerate()
	#	elif sub_position.x == CHUNK_END_SIZE:
	#		chunks[chunk_position + Vector3.RIGHT].regenerate()
	#	if sub_position.z == 0:
	#		chunks[chunk_position + Vector3.FORWARD].regenerate()
	#	elif sub_position.z == CHUNK_END_SIZE:
	#		chunks[chunk_position + Vector3.BACK].regenerate()
	#	if sub_position.y == 0:
	#		chunks[chunk_position + Vector3.DOWN].regenerate()
	#	elif sub_position.y == CHUNK_END_SIZE:
	#		chunks[chunk_position + Vector3.UP].regenerate()


func get_block_global_position(block_global_position):
	var chunk_position = (block_global_position / Chunk.SIZE).floor()
	if chunks.has(chunk_position):
		var chunk = chunks[chunk_position]
		var sub_position = block_global_position.posmod(Chunk.SIZE)
		if chunk.data.has(sub_position):
			#print("Got block from position?", chunk.data[sub_position])
			return chunk.data[sub_position]
	return 0
	
