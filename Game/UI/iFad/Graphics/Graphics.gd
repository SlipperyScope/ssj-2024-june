class_name Graphics extends SpriteFrames

var EmojiString = "Emojis"
func GetEmoji(index:int) -> Texture2D: return get_frame_texture(EmojiString, index)
func GetEmojiCount() -> int: return get_frame_count(EmojiString)

var DanceString = "Dances"
func GetDance(index:int) -> Texture2D: return get_frame_texture(DanceString, index)
func GetDanceCount() -> int: return get_frame_count(DanceString)

# graphics metadata goes in here
