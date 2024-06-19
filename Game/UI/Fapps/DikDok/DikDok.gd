@icon("res://UI/Fapps/DikDok/dikdok_logo.png")
extends Fapp

const BPM:float = 120
const DefaultEmoji = 2
const DefaultDance = 0
const DefaultLength = 4
const MaxFramesString = "MaxFrames"

@onready var _Player:DDPlayer = %DDPlayer
@onready var _EmojiButton:NineButton = %Emoji
@onready var _EmojiTexture:TextureRect = %EmojiTexture
@onready var _EmojiGrid:GridSelector = %EmojiGrid
@onready var _DanceButton:NineButton = %Dance
@onready var _DanceTexture:TextureRect = %DanceTexture
@onready var _DanceGrid:GridSelector = %DanceGrid
@onready var _TextButton:NineButton = %Text
@onready var _TextTexture:TextureRect = %TextTexture

var _File:DikDok_dd
var _DDFM:DDFM
var _Frame:int = 0

# mmm, Dirty Dirty Forbidden Manipulation; definitely not DikDok File Manager
class DDFM:
	signal Updated(what:Prop, e:Args)
	
	enum Prop { Emoji, Dance }
	
	class Args:
		var New
		var Old
		var Frame:int
		func _init(new, old, frame):
			New = new
			Old = old
			Frame = frame
			
	func SetINE(new, old, what:Prop, setter:Callable, emit:bool = true, notequal:Callable = func(n, o): return n != o) -> bool:
		if notequal.call(new, old):
			setter.call()
			if emit: 
				(func():Updated.emit(what, Args.new(new, old, _Frame.call()))).call_deferred()
			return true
		else: return false
	
	var EmojiID:int:
		get: return _File.Emojis[_Frame.call()]
		set(value): SetINE(value, EmojiID, Prop.Emoji, func(): _File.Emojis[_Frame.call()] = value)
	
	var DanceID:int:
		get: return _File.Dances[_Frame.call()]
		set(value): SetINE(value, DanceID, Prop.Dance, func(): _File.Dances[_Frame.call()] = value)
	
	var Emoji:Texture:
		get: return _Source.GetEmoji(EmojiID)
		
	var Dance:Texture: 
		get: return _Source.GetDance(DanceID)
	
	var _File:DikDok_dd
	var _Source:GFX
	var _Frame:Callable
	
	func _init(file:DikDok_dd, source:GFX, frameRef:Callable):
		_File = file
		_Source = source
		_Frame = frameRef

func _ready():
	_LoadFile(null)
	_ConfigDDFM()
	_ConfigUI()

func _ConfigDDFM():
	_DDFM = DDFM.new(_File, null, func():return _Frame)
	_DDFM.Updated.connect(_FileUpdated)
	pass

func _ConfigUI():
	_DanceGrid.Selected.connect(func(index):_DDFM.DanceID = index)
	_DanceButton.ButtonToggled.connect(func(state): _DanceGrid.visible = state)
	for i in 0:#_OSM.OSGraphics.GetDanceCount():
		pass #_DanceGrid.AddItem(null)#_OSM.OSGraphics.GetDance(i))
	
	_EmojiGrid.Selected.connect(func(index):_DDFM.EmojiID = index)
	_EmojiButton.ButtonToggled.connect(func(state): _EmojiGrid.visible = state)
	for i in 0:#_OSM.OSGraphics.GetEmojiCount():
		pass #_EmojiGrid.AddItem(_OSM.OSGraphics.GetEmoji(i))
	
	#_Player.OSGfx = null#_OSM.OSGraphics
	_Player.FrameChanged.connect(_OnFrameChanged)
	_Player.LoadFile(_File)

func _FileUpdated(what:DDFM.Prop, e:DDFM.Args):
	_Player.OnFrameChanged(_Frame)
	return
	match what:
		DDFM.Prop.Emoji:
			_EmojiTexture.texture = _DDFM.Emoji
			_EmojiGrid.Select(_DDFM.EmojiID)
		DDFM.Prop.Dance:
			_DanceTexture.texture = _DDFM.Dance
			_DanceGrid.Select(_DDFM.DanceID)
	pass

func _OnFrameChanged(frame:int):
	_Frame = frame
	_EmojiTexture.texture = _DDFM.Emoji
	_EmojiGrid.Select(_DDFM.EmojiID)
	_DanceTexture.texture = _DDFM.Dance
	_DanceGrid.Select(_DDFM.DanceID)

func _LoadFile(file:DikDok_dd):
	var dd:DikDok_dd
	if !file:
		dd = ResourceLoader.load("res://UI/Fapps/DikDok/DikDok.dd.tres")
		dd.Name = "Untitled"
		var frames =0# _FappData.Data[MaxFramesString]
		dd.FrameCount = frames
		dd.Emojis.resize(frames)
		dd.Dances.resize(frames)
		dd.Emojis.fill(DefaultEmoji)
		dd.Dances.fill(DefaultDance)
	else:
		dd = file.duplicate()
	_File = dd
