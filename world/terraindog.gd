extends Resource
class_name TerrainDog

const SIZE = 16

static func random():
	var random_data = {}
	for x in range(SIZE):
		for y in range(SIZE):
			for z in range(SIZE):
				var vec = Vector3(x, y, z)
				if randf() < 0.01:
					random_data[vec] = randi() % 29 + 1
	return random_data

static func genNoise():
	var noise = OpenSimplexNoise.new()
	noise.seed = "cumflex".hash()
	noise.octaves = 3
	noise.period = 40.0
	noise.persistence = 0.5
	return noise

static func noisy(chunk_position):
	var block_data = {}
	
	if abs(chunk_position.y) > 5 or abs(chunk_position.y) < 5:
		return {}

	var noise = genNoise()
	
	for x in range(SIZE):
		for y in range(SIZE):
			for z in range(SIZE):
				var pos = Vector3(x, y, z)
				if noise.get_noise_2d(chunk_position.x + x, chunk_position.z + z) * SIZE > chunk_position.y + y:
					block_data[pos] = 1
	return block_data

static func bubbly():
	var random_data = {}
	for x in range(SIZE):
		var vec = Vector3(x, 0, 0)
		random_data[vec] = 0
	return random_data

static func flat(chunk_position):
	var data = {}
	# We don't want to define a new BlockStore for every load, 
	# but since this generates per chunk this shouldn't be an issue.
	# We can just free the variable?
	var block_store = BlockStore.new()

	if chunk_position.y != -1:
		return data

	for x in range(SIZE):
		for z in range(SIZE):
			data[Vector3(x, 0, z)] = block_store.getBlock(1)[1]
	block_store = null 
	return data
