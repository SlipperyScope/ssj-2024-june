class_name DDFrame extends PanelContainer

var Emoji:Texture:
	get: return %Emoji.texture
	set(value): %Emoji.texture = value
	
var Dance:Texture:
	get: return %Dance.texture
	set(value): %Dance.texture = value
	
var Text:String
var Background:Texture:
	get: return %Background.texture
	set(value): %Background.texture = value

func SetAll(emoji, dance, text, background):
	Emoji = emoji
	Dance = dance
	Text = text
	Background = background
	
