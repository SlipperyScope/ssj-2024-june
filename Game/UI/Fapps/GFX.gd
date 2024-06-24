class_name GFX extends SpriteFrames

func Get(setName:String, index:int) -> Texture: return get_frame_texture(setName, index)
func Count(setName:String) -> int: return get_frame_count(setName)

@export var Metadata:Dictionary
