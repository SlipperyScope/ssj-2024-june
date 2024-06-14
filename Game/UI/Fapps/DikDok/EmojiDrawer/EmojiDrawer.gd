extends GridContainer

signal TileSelected(index:int)

var _SetName = "default"

@export var _Sets:EmojiSets
var _Tile = preload("res://UI/Fapps/DikDok/EmojiDrawer/EmojiTile.tscn")

func _ready():
	for i in range(0,15):
		_AddTile(i)

func _AddTile(index:int):
	var texture = _Sets.get_frame_texture(_SetName,index)
	var tile:EmojiTile = _Tile.instantiate()
	tile.SetTexture(texture)
	tile.Pressed.connect(func():TileSelected.emit(index))
	add_child(tile)
	
