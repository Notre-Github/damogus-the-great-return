extends MeshInstance3D

@onready var colShape = $StaticBody3D/TerrainCollision

@export var chunk_size = 100.0
@export var height_ratio = 7.27
@export var colShape_size_ratio = 0.1

var img = Image.new()
var shape = HeightMapShape3D.new()

func update_terrain(_height_ratio, _colShape_size_ratio):
	material_override.set("shader_param/height_ratio", _height_ratio)
	img.load("res://Sprites/perlin-noise-texture.png")
	#await img
	img.convert(Image.FORMAT_RF)
	img.resize(img.get_width() * _colShape_size_ratio, img.get_height() * _colShape_size_ratio)
	var data = img.get_data().to_float32_array()
	for i in range (0, data.size()):
		data[i] *= _height_ratio
	colShape.shape.map_width = img.get_width()
	colShape.shape.map_depth = img.get_height()
	colShape.shape.map_data = data
	var scale_ratio = chunk_size / float (img.get_width())
	colShape.scale = Vector3(scale_ratio, 1, scale_ratio)

func _ready():
	update_terrain(height_ratio, colShape_size_ratio)
