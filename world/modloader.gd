extends Node
class_name ModLoader

var modPath = "../mods"

static func _read_folder(scan_dir : String):
	var dir = Directory.new()
	var mods = []
	if dir.open(scan_dir) != OK:
		printerr("Warning: could not open directory: ", scan_dir)
		return []

	if dir.list_dir_begin(true, true) != OK:
		printerr("Warning: could not list contents of: ", scan_dir)
		return []
	
	print("[ModLoader] --> 'mods/' located. Trying to detect mods...")
	
	var _file = dir.get_next()
	
	while _file:
		if dir.current_is_dir():
			mods.append(_file)
		
		_file = dir.get_next()
	return mods
	

static func load_mods():
	var mods = _read_folder("mods")
	print("[ModLoader] --> Loaded:")
	for mod in mods:
		print("\t %s" % mod)
	return mods

static func inject_blocks():
	var mods = load_mods()
	var Block = load("res://world/block.gd")
	for mod in mods:
		print(mod)
	return []
