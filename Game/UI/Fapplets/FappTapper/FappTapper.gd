extends Launcher

var _Tile = preload("res://UI/Fapplets/FappTapper/Tile.tscn")

var _Tiles:Array[TextureButton]

## Handle OSM messages, or don't
func Notify(message: OSM.Msg):
	pass

## Updates list of known fapplets
func UpdateFappList(list: Array[OSM.FappInfo]):
	for child in %Tiles.get_children():
		%Tiles.remove_child(child)
	_Tiles = []
	for info in list:
		var newTile: TextureButton = _Tile.instantiate()
		newTile.texture_normal = info.Manifest.FappIcon
		_Tiles.append(newTile)
		newTile.pressed.connect(OnTilePress.bind(info.Manifest.Name))
		%Tiles.add_child(newTile)

func OnTilePress(name:String):
	print("You clicked %s" % name)
