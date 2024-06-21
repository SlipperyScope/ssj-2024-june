class_name FappData

var ID:int
var Name:String
var Icon:Texture2D
var Gfx:GFX
var Sfx:SFX
var Store:Dictionary = {}

func _init(id, name, icon, gfx, sfx):
	ID = id
	Name = name
	Icon = icon
	Gfx = gfx
	Sfx = sfx
