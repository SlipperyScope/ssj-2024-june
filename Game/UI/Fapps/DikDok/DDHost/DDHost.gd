class_name DDHost extends SubViewportContainer

@onready var _Frame:DDFrame = %Frame

func SetFrameData(dance, emoji, text, background):
	_Frame.SetAll(emoji, dance, text, background)
	
