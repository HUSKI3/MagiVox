extends Node
class_name BlockStore

var Block = load("res://world/block.gd")

var block_data = []
var defaults = [
	Block.new(
		"Empty",
		"air",
		""
	),
	Block.new(
		"Stone Block",
		"stone_block",
		"res://assets/blocks/stone/default"
	),
	Block.new(
		"Dirt Block",
		"dirt_block",
		"res://assets/blocks/grass/dirt"
	)
]

func getBlocks():
	# here we get blocks from all known locations
	pass

func _init():
	# Load defaults
	for x in defaults:
		block_data.append(x)
	#print("[BlockStore] --> Syncing ModLoader...")
	# here we want to load the blocks from other sources
	var mod_blocks = ModLoader.inject_blocks()
	for block in mod_blocks:
		block_data.append(block)

func getBlock(block_id):
	return [block_data[block_id], block_id]
