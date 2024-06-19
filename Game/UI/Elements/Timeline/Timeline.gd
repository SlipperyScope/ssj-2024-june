class_name Timeline extends PanelContainer

var _ButtonScene:PackedScene = preload("res://UI/Elements/NineButton/NineButton.tscn")

signal FrameChanged(index:int)

@export var _Padding:int = 4
@export var _FrameCount:int = 4
@export var BPM:int = 120

@onready var _PlayButton:TextureButton = %Play
@onready var _StopButton:TextureButton = %Stop
@onready var _Frames:HBoxContainer = %Frames

var Frame:int = 0
var Playing:bool = false

var _Buttons:Array[NineButton] = []
var _Group = ButtonGroup.new()
var _Time:float = 0
var _NextFrame:float = 2^16

func _ready():
	_ConfigLayout()
	_ConfigButtons()

func _ConfigLayout():
	_Frames.add_theme_constant_override("separation", _Padding)
	%Padding.add_theme_constant_override("margin_top", _Padding)
	%Padding.add_theme_constant_override("margin_left", _Padding)
	%Padding.add_theme_constant_override("margin_bottom", _Padding)
	%Padding.add_theme_constant_override("margin_right", _Padding)
	%Buttons.add_theme_constant_override("margin_right", _Padding)

func _ConfigButtons():
	_PlayButton.pressed.connect(Play)
	_StopButton.pressed.connect(Stop)

func Play():
	_PlayButton.visible = false
	_StopButton.visible = true
	_Time = 0
	_NextFrame = 0
	_SetNextFrameTime()
	SetFrame(0)
	Playing = true

func Stop():
	_PlayButton.visible = true
	_StopButton.visible = false
	SetFrame(0)
	Playing = false

func SetFrame(index:int):
	print("setting frame to %s"%index)
	_Buttons[index].Clickable.button_pressed = true

func SetFrameCount(num:int):
	_FrameCount = num
	for button in _Buttons:
		button.queue_free()
	_Group = ButtonGroup.new()
	_Buttons.clear()
	_Buttons.resize(num)
	for i in num:
		var frame:NineButton = _ButtonScene.instantiate()
		_Buttons[i] = frame
		frame.ButtonToggled.connect(OnButtonToggled.bind(i))
		frame.size_flags_horizontal = SIZE_EXPAND_FILL
		_Frames.add_child(frame)
		frame.Clickable.button_group = _Group
	SetFrame(0)

func OnButtonToggled(state:bool, index:int):
	if state:
		Frame = index 
		FrameChanged.emit(index)

func _process(delta):
	if Playing:
		_Time += delta
		if _Time > _NextFrame:
			var next = (Frame + 1) % _FrameCount
			print("setting frame from %s to %s"%[Frame,next])
			SetFrame(next)
			_SetNextFrameTime()

func _SetNextFrameTime():
	_NextFrame += BPM / 60.0 







