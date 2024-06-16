extends Fapp

var _Tile = preload("res://UI/Fapps/FappTapper/Tile.tscn")

var _Tiles:Dictionary = {}
var _Fapplets:Dictionary

func _ready():
	var fapplets = _OSM.GetFapplets()
	_OSM.FappListUpdated.connect(UpdateFappList)

func UpdateFappList():
	var old = _Fapplets
	var new = _OSM.GetFapplets()
	_Fapplets = new
	for key in old.keys():
		if !new.has(key):
			_Tiles[key].queue_free()
			_Tiles.erase(key)
	for key in new.keys():
		if !old.has(key):
			_AddTile(key)
	
func _AddTile(id:int):
		var manifest:Manifest = _Fapplets[id].Manifest
		var newTile: TextureButton = _Tile.instantiate()
		newTile.texture_normal = manifest.FappIcon
		_Tiles[id] = newTile
		newTile.pressed.connect(OnTilePress.bind(id))
		%Tiles.add_child(newTile)

func OnTilePress(id:int):
	_OSM._Display(id)
