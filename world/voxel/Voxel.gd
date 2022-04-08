extends Node

# I DONT KNOW HOW IT WORKS, BUT IT WORKS!
const vertex: Dictionary = {"top": [Vector3(0.5,0.5,-0.5),Vector3(-0.5,0.5,0.5),Vector3(-0.5,0.5,-0.5),Vector3(0.5,0.5,-0.5),Vector3(0.5,0.5,0.5),Vector3(-0.5,0.5,0.5)],
"bottom":[Vector3(-0.5,-0.5,-0.5),Vector3(-0.5,-0.5,0.5),Vector3(-0.5,-0.5,0.5),Vector3(-0.5,-0.5,0.5),Vector3(0.5,-0.5,0.5),Vector3(0.5,-0.5,-0.5)], #bottom
"front":[Vector3(-0.5,0.5,0.5),Vector3(0.5,-0.5,0.5),Vector3(-0.5,-0.5,0.5),Vector3(-0.5,0.5,0.5),Vector3(0.5,0.5,0.5),Vector3(0.5,-0.5,0.5)], #front
"back":[Vector3(-0.5,-0.5,-0.5),Vector3(0.5,0.5,-0.5),Vector3(-0.5,0.5,-0.5),Vector3(-0.5,-0.5,-0.5),Vector3(0.5,-0.5,-0.5),Vector3(0.5,0.5,-0.5)], #back
"left":[Vector3(-0.5,-0.5,-0.5),Vector3(-0.5,0.5,-0.5),Vector3(-0.5,0.5,0.5),Vector3(-0.5,-0.5,0.5),Vector3(-0.5,-0.5,-0.5),Vector3(-0.5,0.5,0.5)], #left
"right":[Vector3(0.5,0.5,0.5),Vector3(0.5,0.5,-0.5),Vector3(0.5,-0.5,-0.5),Vector3(0.5,-0.5,0.5),Vector3(0.5,0.5,0.5),Vector3(0.5,-0.5,-0.5)]} #right

#const uv: Array = [Vector2(0,0),Vector2(0,1),Vector2(1,0)] # Needs to fix and then I can add a chunk system...
const uv: Dictionary = {"top":[Vector2(1,0),Vector2(0,1),Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,0)]}

static func _gen_voxel(top: bool = true,bottom: bool = true,front: bool = true,back: bool = true,left: bool = true,right: bool = true) -> Mesh:
  var st: SurfaceTool = SurfaceTool.new()
  var mat = SpatialMaterial.new()
  mat.albedo_texture = load("res://world/textures/texture_sheet.png")
  mat.albedo_color = Color.white
  st.begin(Mesh.PRIMITIVE_TRIANGLES)
  st.set_material(mat)
  
  # Top polygon
  if top:
    st.add_triangle_fan(vertex["top"],uv["top"])
  # Bottom polygon
  if bottom:
    st.add_triangle_fan(vertex["bottom"],uv["top"])
  if front:
  # North polygon
    st.add_triangle_fan(vertex["front"],uv["top"])
  if back:
  # South polygon
    st.add_triangle_fan(vertex["back"],uv["top"])
  if left:
  # East polygon
    st.add_triangle_fan(vertex["left"],uv["top"])
  if right:
  # West polygon
    st.add_triangle_fan(vertex["right"],uv["top"])
  
  st.generate_tangents()
  var result: Mesh = Mesh.new()
  st.commit(result)
  return result
