extends StaticBody
class_name Chunk

const SIZE = 16
const TEXTURE_SIZE = 8
const TEXTURE_TILE_SIZE = 1.0 / TEXTURE_SIZE

var position = Vector3()
var data = {
	
} # Here we store the chunk data


onready var world = get_parent()

func _ready():
	# Set position
	transform.origin = position * SIZE
	name = " Chunk at ({pos})".format({'pos':str(position)})
	# Assume world gen
	data = TerrainDog.flat(position, world.mod_loader)
	# Gen colliders
	_gen_colliders()
	var _thread := Thread.new()
	_thread.start(self, "_gen_mesh")


func _gen_colliders():
	collision_layer = 0xFFFFF
	collision_mask = 0xFFFFF
	for b_pos in data.keys():
		# var block = data[b_pos]
		#if block_id not in Blocks.NoCollision: # Disable these block colliders?
		_create_block_collider(b_pos)

func _create_block_collider(b_sub_pos):
	var collider = CollisionShape.new()
	collider.shape = BoxShape.new()
	collider.shape.extents = Vector3.ONE / 2
	collider.transform.origin = b_sub_pos + Vector3.ONE / 2
	add_child(collider)

func _gen_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	for block_position in data.keys():
		var block = data[block_position]
		var block_id = block
		block_mesh(surface_tool, block_position, block_id)

	# Create the chunk's mesh from the SurfaceTool data.
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	surface_tool.index()
	var array_mesh = surface_tool.commit()
	var mi = MeshInstance.new()
	mi.mesh = array_mesh
	mi.material_override = preload("res://world/textures/material.tres")
	add_child(mi)

func block_mesh(surface_tool, block_sub_position, block_id):
	# So here we want to draw the block mesh
	# I dont like the approach from the official "Voxel Game" demo
	# So I tried writing my own
	var verts = calculate_block_verts(block_sub_position)
	var uvs = calculate_block_uvs(block_id)
	var top_uvs = uvs
	var bottom_uvs = uvs

	for vector_direction in [Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK, Vector3.DOWN, Vector3.UP]:
		var other_block_position = block_sub_position + vector_direction
		var other_block_id = 0
		if other_block_position.x == SIZE:
			other_block_id = world.get_block_global_position(other_block_position + position * SIZE)
		elif data.has(other_block_position):
			other_block_id = data[other_block_position]
		if block_id != other_block_id: # and is_block_transparent(other_block_id):
			_draw_block_face(surface_tool, [verts[2], verts[0], verts[3], verts[1]], uvs)
			_draw_block_face(surface_tool, [verts[7], verts[5], verts[6], verts[4]], uvs)
			_draw_block_face(surface_tool, [verts[6], verts[4], verts[2], verts[0]], uvs)
			_draw_block_face(surface_tool, [verts[3], verts[1], verts[7], verts[5]], uvs)
			_draw_block_face(surface_tool, [verts[4], verts[5], verts[0], verts[1]], bottom_uvs)
			_draw_block_face(surface_tool, [verts[2], verts[3], verts[6], verts[7]], top_uvs)



static func calculate_block_uvs(block_id):
	var row = block_id / TEXTURE_SIZE
	var col = block_id % TEXTURE_SIZE

	return [
		TEXTURE_TILE_SIZE * Vector2(col, row),
		TEXTURE_TILE_SIZE * Vector2(col, row + 1),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row),
		TEXTURE_TILE_SIZE * Vector2(col + 1, row + 1),
	]


static func calculate_block_verts(block_position):
	return [
		Vector3(block_position.x, block_position.y, block_position.z),
		Vector3(block_position.x, block_position.y, block_position.z + 1),
		Vector3(block_position.x, block_position.y + 1, block_position.z),
		Vector3(block_position.x, block_position.y + 1, block_position.z + 1),
		Vector3(block_position.x + 1, block_position.y, block_position.z),
		Vector3(block_position.x + 1, block_position.y, block_position.z + 1),
		Vector3(block_position.x + 1, block_position.y + 1, block_position.z),
		Vector3(block_position.x + 1, block_position.y + 1, block_position.z + 1),
	]

func _draw_block_face(surface_tool, verts, uvs):
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[3]); surface_tool.add_vertex(verts[3])

	surface_tool.add_uv(uvs[2]); surface_tool.add_vertex(verts[2])
	surface_tool.add_uv(uvs[1]); surface_tool.add_vertex(verts[1])
	surface_tool.add_uv(uvs[0]); surface_tool.add_vertex(verts[0])


func regenerate():
	# Clear out all old nodes first.
	for c in get_children():
		remove_child(c)
		c.queue_free()

	# Then generate new ones.
	_gen_colliders()
	_gen_mesh()
