class_name FappData

var ID:int
var Name:String
var Icon:Texture2D
var Gfx:GFX
var Store:Dictionary = {}

func _init(id, name, icon, gfx):
	ID = id
	Name = name
	Icon = icon
	Gfx = gfx
