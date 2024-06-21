class_name SFX extends Resource

@export var General:Array[WAD]

func GetWadByName(name:String) -> WAD:
	for wad in General:
		if wad.Name == name:
			return wad
	return null
