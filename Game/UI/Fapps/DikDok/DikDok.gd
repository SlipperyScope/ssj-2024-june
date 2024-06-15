@icon("res://UI/Fapps/DikDok/dikdok_logo.png")
extends Fapp

var _EmojiSets:EmojiSets = ResourceLoader.load("res://UI/Fapps/DikDok/Emojis/EmojiSets.tres")
@onready var Drawer:DikDok_Drawer = %Drawer
@onready var EmojiButton:TextureButton = %EmojiButton
var Buttons:Dictionary
var Emojis:Dictionary
var EmojiSet = "default"
var _CurrentFrame:int = 2

func _ready():
	Buttons = { 1:%FrameButtons/Button01, 2:%FrameButtons/Button02, 3:%FrameButtons/Button03, 4:%FrameButtons/Button04 }
	for key in Buttons.keys():
		Buttons[key].pressed.connect(SetFrame.bind(key))
	%EmojiButton.pressed.connect(EmojiButtonPressed)
	Drawer.ItemSelected.connect(TileSelected)
	SetDrawerContent.call_deferred()

func SetDrawerContent():
	Drawer.SetContent(_EmojiSets, EmojiSet, 4)
	NewDikDok()

func TileSelected(index:int):
	EmojiButton.texture_normal = _EmojiSets.get_frame_texture(EmojiSet, index)
	Emojis[_CurrentFrame] = index
	
func EmojiButtonPressed():
	Drawer.visible = !Drawer.visible

func SetFrame(num:int):
	if (num != _CurrentFrame):
		Buttons[_CurrentFrame].Selected = false;
		_CurrentFrame = num
		TileSelected(Emojis[num])
		Buttons[_CurrentFrame].Selected = true;
		Drawer.SelectItem(Emojis[num])

func NewDikDok():
	Emojis = {1:9,2:9,3:9,4:9}
	SetFrame(1)

func LoadDikDok(file:DikDok_dd):
	pass
