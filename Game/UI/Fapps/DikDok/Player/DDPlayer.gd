class_name DDPlayer extends MarginContainer

signal FrameChanged(index:int)

@onready var _Host:DDHost = %DdHost
@onready var _Timeline = %Timeline
@onready var _PlayButton = %PlayButton
@onready var _Frames = %FrameButtons

@export var DD:DikDok_dd
@export var _GFX:GFX

var _File:DikDok_dd

func _ready():
	if DD:
		Load(DD,1)
		
# Frames are zero-indexed
func Load(file:DikDok_dd, frame = 0, autoplay = false):
	_File = file
	SetFrame(frame)

func SetFrame(num):
	var dance = _GFX.Get("Dances", _File.Dances[num])
	var emoji = _GFX.Get("Emojis", _File.Emojis[num])
	var text = ["Hello", "World"][num]
	_Host.SetFrameData(dance, emoji, text, Texture2D.new())
	pass
