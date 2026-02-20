@tool
class_name WaveSquare
extends Node3D

@export_group("Dimensions")
@export var width: float = 4.0:
	set(v): width = v; _setup_simulation()
@export var depth: float = 4.0:
	set(v): depth = v; _setup_simulation()

@export_group("Tessellation")
@export_range(4, 100) var subdiv: int = 25:
	set(v): subdiv = v; _setup_simulation()

@export_group("Physics")
@export var damping: float = 0.98
@export var stiffness: float = 0.15
@export var auto_ripple: bool = false 

@export_group("Visuals")
@export var albedo: Color = Color.BLUE:
	set(v): albedo = v; _update_material_parameters()
@export_range(0, 1) var roughness: float = 0.2:
	set(v): roughness = v; _update_material_parameters()

var heights: PackedFloat32Array
var velocities: PackedFloat32Array
var mesh_instance: MeshInstance3D
var static_body: StaticBody3D
var mat: ShaderMaterial

func _ready() -> void:
	mesh_instance = get_node_or_null("MeshInstance3D")
	static_body = get_node_or_null("MeshInstance3D/StaticBody3D")
	_setup_simulation()

func _setup_simulation() -> void:
	var size = subdiv + 1
	heights = PackedFloat32Array()
	velocities = PackedFloat32Array()
	heights.resize(size * size)
	velocities.resize(size * size)
	heights.fill(0.0)
	velocities.fill(0.0)
	
	if mesh_instance:
		_generate_mesh_structure()

func _process(_delta: float) -> void:
	if heights.is_empty(): return
	
	if auto_ripple and Engine.get_frames_drawn() % 60 == 0:
		impact(randi() % subdiv, randi() % subdiv, 0.5)
		
	_calculate_physics()
	_apply_to_mesh()

func _calculate_physics() -> void:
	var size = subdiv + 1
	var new_heights = heights.duplicate()
	for j in range(1, subdiv):
		for i in range(1, subdiv):
			var idx = j * size + i
			var neighbors = heights[idx-1] + heights[idx+1] + heights[idx-size] + heights[idx+size]
			var force = (neighbors * 0.25 - heights[idx]) * stiffness
			velocities[idx] = (velocities[idx] + force) * damping
			new_heights[idx] += velocities[idx]
	heights = new_heights

func _apply_to_mesh() -> void:
	if not mesh_instance or not mesh_instance.mesh: return
	var am = mesh_instance.mesh as ArrayMesh
	if am.get_surface_count() == 0: return

	var arrays = am.surface_get_arrays(0)
	var verts = arrays[Mesh.ARRAY_VERTEX]
	
	# Direct 1:1 mapping because we used an indexed grid
	for i in range(heights.size()):
		verts[i].y = heights[i]

	arrays[Mesh.ARRAY_VERTEX] = verts
	am.clear_surfaces()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	am.surface_set_material(0, mat)

func _generate_mesh_structure() -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var size = subdiv + 1
	var dx = width / subdiv
	var dz = depth / subdiv
	
	# 1. Create unique vertices in a grid
	for j in range(size):
		for i in range(size):
			var x = -width/2.0 + i * dx
			var z = -depth/2.0 + j * dz
			st.add_vertex(Vector3(x, 0, z))
	
	# 2. Stitch them together with indices
	for j in range(subdiv):
		for i in range(subdiv):
			var i0 = j * size + i
			var i1 = i0 + 1
			var i2 = (j + 1) * size + i
			var i3 = i2 + 1
			st.add_index(i0); st.add_index(i1); st.add_index(i2)
			st.add_index(i1); st.add_index(i3); st.add_index(i2)

	st.generate_normals()
	
	mat = ShaderMaterial.new()
	mat.shader = Shader.new()
	mat.shader.code = "shader_type spatial; uniform vec4 albedo:source_color; uniform float roughness:hint_range(0,1); void fragment(){ALBEDO=albedo.rgb;ROUGHNESS=roughness;} void light(){float dot_nl=clamp(dot(NORMAL,LIGHT),0.0,1.0);DIFFUSE_LIGHT+=LIGHT_COLOR*ALBEDO.rgb*dot_nl*ATTENUATION;}"
	_update_material_parameters()
	
	mesh_instance.mesh = st.commit(ArrayMesh.new())

func _update_material_parameters():
	if mat:
		mat.set_shader_parameter("albedo", albedo)
		mat.set_shader_parameter("roughness", roughness)

func impact(x: int, z: int, force: float):
	var size = subdiv + 1
	var idx = z * size + x
	if idx >= 0 and idx < heights.size():
		heights[idx] += force

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = get_viewport().get_camera_3d()
		if not camera or not static_body: return
		
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000.0
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		if result and (result.collider == static_body):
			var local_p = to_local(result.position)
			var gx = int(((local_p.x + width/2.0) / width) * subdiv)
			var gz = int(((local_p.z + depth/2.0) / depth) * subdiv)
			impact(gx, gz, 2.0)
