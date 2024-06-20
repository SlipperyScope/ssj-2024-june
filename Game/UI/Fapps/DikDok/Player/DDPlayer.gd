class_name DDPlayer extends MarginContainer

signal FrameChanged(index:int)

@onready var _Host:DDHost = %DdHost
@onready var _Timeline = %Timeline
@onready var _PlayButton = %PlayButton
@onready var _Frames:GridSelector = %FrameButtons

@export var DD:DikDok_dd
@export var _GFX:GFX

var _File:DikDok_dd
var _Frame:int
var _Time:float
var _PlayStart:float = INF
var _NextFrame:float

func Load(file:DikDok_dd, frame = 0, autoplay = false):
	_File = file
	_Frames.Columns = file.FrameCount
	for f in file.FrameCount: _Frames.AddButton()
	SetFrame(frame)

func ReloadFrame():
	_SetFrame(_Frame, true)

func SetFrame(frame):
	_Frames.Select(frame)

func SetShowPlayButton(allow:bool = true): _PlayButton.visible = allow
func SetAllowFrameSelect(allow:bool = true): %Blocker.visible = !allow

func _ready():
	_Frames.Selection.connect(_SetFrame)
	_PlayButton.toggled.connect(_SetPlay)
	if DD:
		Load(DD,0)

func _process(delta):
	_Time += delta
	if (_Time >= _PlayStart):
		SetFrame((_Frame + 1) % _File.FrameCount)
		_PlayStart += _File.BPM / 60

func _SetFrame(num, noSignal:bool = false):
	_Frame = num
	var dance = _GFX.Get("Dances", _File.Dances[num])
	var emoji = _GFX.Get("Emojis", _File.Emojis[num])
	var text = "test id: %s"%_File.Words[num]
	var background = _File.Background
	_Host.SetFrameData(dance, emoji, text, background)
	if !noSignal: FrameChanged.emit(num)

func _SetPlay(state):
	SetFrame(0)
	_PlayStart = _Time + _File.BPM / 60 if state else INF
