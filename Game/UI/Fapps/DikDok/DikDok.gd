@icon("res://UI/Fapps/DikDok/dikdok_logo.png")
extends Fapp

class Model:
	var Emojis:Dictionary = {}
	
var _CurrentFrame:int = 0

func _ready():
	%FrameButtons/Button01.pressed.connect(FrameButtonPressed.bind(1))
	%FrameButtons/Button02.pressed.connect(FrameButtonPressed.bind(2))
	%FrameButtons/Button03.pressed.connect(FrameButtonPressed.bind(3))
	%FrameButtons/Button04.pressed.connect(FrameButtonPressed.bind(4))
	
	%EmojiButton.toggled.connect(EmojiButtonToggled)
	%EmojiDrawer.TileSelected.connect(TileSelected)
	%EmojiDrawer.visible = false
	
func TileSelected(index:int):
	print(index)

func FrameButtonPressed(frame:int):
	_CurrentFrame = frame
	
func EmojiButtonToggled(state:bool):
	%EmojiDrawer.visible = state