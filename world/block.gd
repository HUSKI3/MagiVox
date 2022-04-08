extends Node
class_name Block

var cool_name
var identifier
var texture

func _init(name, id, pos):
	self.cool_name = name
	self.identifier = id
	self.texture = pos

func stringify():
	return "(%s)::%s" % [self.cool_name, self.identifier]
