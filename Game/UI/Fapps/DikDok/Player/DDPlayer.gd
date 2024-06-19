class_name DDPlayer extends MarginContainer

signal FrameChanged(index:int)

@onready var _Renderer:MarginContainer = %Renderer
@onready var _Timeline:Timeline = %Timeline
@onready var _Dance:TextureRect = %Dance
@onready var _Emoji:TextureRect = %Emoji

@export var ShowTimeline:bool = true

var OSGfx#:OSGraphics
var _File:DikDok_dd

func _ready():
	_Timeline.FrameChanged.connect(OnFrameChanged)

func LoadFile(file:DikDok_dd, ):
	_File = file
	_Timeline.SetFrameCount(file.FrameCount)

func OnFrameChanged(index:int):
	if _File && OSGfx:
		_Dance.texture = OSGfx.GetDance(_File.Dances[index])
		_Emoji.texture = OSGfx.GetEmoji(_File.Emojis[index])
	FrameChanged.emit(index)
