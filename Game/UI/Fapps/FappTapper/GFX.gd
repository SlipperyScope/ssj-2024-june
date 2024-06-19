class_name GFX extends SpriteFrames

func Get(setName:String, index:int) -> Texture2D: return get_frame_texture(setName, index)
func Count(setName:String) -> int: return get_frame_count(setName)

# graphics metadata goes in here
