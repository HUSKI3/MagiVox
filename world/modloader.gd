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
	var Block = preload("res://world/block.gd")
	for mod in mods:
		print(mod)
	return []

static func gen_atlas(ImagePaths:Array):
	var Images = []
	var TotalSize = {"width":0,"height":0}
	var Coords = {}
	var max_height = 0
	
	for path in ImagePaths:
		var _tmp = Image.new()
		var e = _tmp.load(path)
		if e == OK:
			Images.append(
				_tmp
			)
			TotalSize["width"] += _tmp.data['width']
			TotalSize["height"] += _tmp.data['height']
			if TotalSize["height"] > max_height:
				max_height = TotalSize["height"]
				
		else:  printerr("[ModLoader] Failed to load path at {path}, does it exist?".format({"path":path}))
		
	print(Images,TotalSize)
	# New image
	var Result = Image.new()
	Result.create(
		TotalSize["width"], 
		max_height, 
		false, 
		Image.FORMAT_RGBA8
	)
	Result.lock()
	
	var texture_id = 0
	var x = 0
	var y = 0
	
	for ImageIndex in Images.size():
		var current = Images[ImageIndex]
		current.lock()
		for _x in range(current.get_size().x):
			for _y in range(current.get_size().y):
				var pixel = current.get_pixel(_x,_y)
				Result.set_pixel(_x+x,_y+y, pixel)
				print("pixel at", _x, _y)
		
		Coords[[x,y]] = texture_id
		#Result.blit_rect(Images[ImageIndex], Images[ImageIndex].get_used_rect(), Vector2(x,y))
		print("Built an image at {x}:{y}".format({"x":x, "y":y}))
		x += Images[ImageIndex].data["width"]
		texture_id += 1
		
	Result.unlock()
	#Result.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_SRGB, 0)
	return Result
