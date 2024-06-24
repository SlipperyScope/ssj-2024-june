class_name SFX extends Resource

@export var General:Array[WAD]
@export var Songs:Array[WAD]

var SongSets = {"General":func():return General, "Songs":func():return Songs}

func GetWadByName(songSet:String, name:String) -> WAD:
	for wad in SongSets[songSet].call():
		if wad.Name == name:
			return wad
	return null

func GetWadByID(songSet:String, id:int) -> WAD:
	return SongSets[songSet][id]
