tool
class_name BlockResource extends Resource

enum MINING_TOOLS{ # TEMPORARY
  None,
  Hand,
  Pickaxe,
  Axe,
  Hoe,
  Shovel,
  Spoon # Place holder
}

enum TOOL_LEVEL{ # TEMPORARY
  None,
  Wood,
  Stone,
  Iron,
  Diamond,
  Emerald # Place holder
}

export var name: String = "None"
export var resistance: int = 1
export var durability: int = 1
export(float, 0, 1) var slipperyt: float = 0
export var transparent: bool = false
export var texture_on_atlas: Rect2 # TEMPORARY

#export(MINING_TOOLS) var need_tool: int = 0
#export(TOOL_LEVEL) var tool_level: int

var need_tool: int
var tool_level: int
var effective_tool: int

# Сomfort
func _get(p):
  if p == 'Tool/need_tool':
    return need_tool
  elif p == 'Tool/tool_level':
    return tool_level
  elif p == 'Tool/effective_tool':
    return effective_tool

func _set(p, value):
  if p == 'Tool/need_tool':
    need_tool = value
    return true
  elif p == 'Tool/tool_level':
    tool_level = value
    return true
  elif p == 'Tool/effective_tool':
    effective_tool = value
    return true

func _get_property_list():
  var final: Array = []
  
  final.append({
    'hint': PROPERTY_HINT_ENUM,
    'hint_string': MINING_TOOLS,
    'usage': PROPERTY_USAGE_DEFAULT,
    'name': 'Tool/need_tool',
    'type': TYPE_INT })
  
  final.append({
    'hint': PROPERTY_HINT_ENUM,
    'hint_string': TOOL_LEVEL,
    'usage': PROPERTY_USAGE_DEFAULT,
    'name': 'Tool/tool_level',
    'type': TYPE_INT })
  
  final.append({
    'hint': PROPERTY_HINT_ENUM,
    'hint_string': MINING_TOOLS,
    'usage': PROPERTY_USAGE_DEFAULT,
    'name': 'Tool/effective_tool',
    'type': TYPE_INT })
  
  return final
