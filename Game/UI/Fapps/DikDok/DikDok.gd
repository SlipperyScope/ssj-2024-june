@icon("res://UI/Fapps/DikDok/dikdok_logo.png")
extends Fapp

const BPM:float = 120
const DefaultEmoji = 2
const DefaultDance = 0

@onready var _EmojiButton:PanelButton = %EmojiButton
@onready var _DanceButton:PanelButton = %DanceButton
@onready var _Emojis:GridSelector = %Emojis
@onready var _Dances:GridSelector = %Dances
@onready var _Frames:Array[PanelButton] = [%Frames/F0, %Frames/F1, %Frames/F2, %Frames/F3]

var _Frame:int = 0
var _FrameButtonGroup:ButtonGroup

var _File:DikDok_dd

func _ready():
	if !_OSM: _OSM = OSM.new() #Delete this - for testing only
	_ConfigFrameButtons()
	_ConfigEmojiButton()
	_ConfigDanceButton()
	_LoadFile(null)

func _ConfigFrameButtons():
	var group:ButtonGroup = ButtonGroup.new()
	_FrameButtonGroup = group
	#group.pressed.connect(_OnFramePressed)
	for i in _Frames.size():
		_Frames[i].button_group = group
		_Frames[i].pressed.connect(_LoadFrame.bind(i))

func _LoadFrame(num:int):
	_Frame = num
	var emoji = _File.Emojis[num]
	_Emojis.Select(_File.Emojis[num])
	_Frames[num].button_pressed = true
	_UpdateEmojiButton()
	_UpdateDanceButton()

func _LoadFile(file:DikDok_dd):
	var dd:DikDok_dd
	if !file:
		dd = ResourceLoader.load("res://UI/Fapps/DikDok/DikDok.dd.tres")
		dd.Name = "Untitled"
		dd.Emojis.resize(_Frames.size())
		dd.Emojis.fill(DefaultEmoji)
		dd.Dances.resize(_Frames.size())
		dd.Dances.fill(DefaultDance)
	else:
		dd = file.duplicate()
	_File = dd
	_LoadFrame(0)

func _ConfigEmojiButton():
	_EmojiButton.toggled.connect(_OnEmojiButtonToggled)
	for i in _OSM.OS_Graphics.GetEmojiCount():
		_Emojis.AddItem(_OSM.OS_Graphics.GetEmoji(i))
	_Emojis.ElementSelected.connect(_OnEmojiSelected)

func _ConfigDanceButton():
	_DanceButton.toggled.connect(_OnDanceButtonToggled)
	for i in _OSM.OS_Graphics.GetDanceCount():
		_Dances.AddItem(_OSM.OS_Graphics.GetDance(i))
	_Dances.ElementSelected.connect(_OnDanceSelected)

func _OnEmojiButtonToggled(state:bool):
	_Emojis.visible = state

func _OnDanceButtonToggled(state:bool):
	_Dances.visible = state

func _OnEmojiSelected(index:int):
	_File.Emojis[_Frame] = index
	_UpdateEmojiButton()

func _OnDanceSelected(index:int):
	_File.Dances[_Frame] = index
	_UpdateDanceButton()

func _UpdateEmojiButton():
	_EmojiButton.Display.texture = _OSM.OS_Graphics.GetEmoji(_File.Emojis[_Frame])

func _UpdateDanceButton():
	var dance = _OSM.OS_Graphics.GetDance(_File.Dances[_Frame])
	_DanceButton.Display.texture = dance
	%DanceDisplay.texture = dance

