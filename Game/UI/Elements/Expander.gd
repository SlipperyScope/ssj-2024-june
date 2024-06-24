class_name Expander extends Container

signal toggled(state:bool)

@export var _ButtonPath:NodePath
@export var _ItemsToHide:Array[NodePath]
@export var _StartOpen = false
@export_enum("Hide Panel", "Hide Content") var _CloseBehavior:int = 0

var _Button:BaseButton
var _ContentPanel:Container
var _IsOpen = true

func SetPanelState(open:bool):
	_Toggled(!_IsOpen)

func _ready():
	_Button = get_node(_ButtonPath)
	if _Button.toggle_mode:
		_Button.toggled.connect(_Toggled)
	else:
		_Button.pressed.connect(func():_Toggled(!_IsOpen))
	SetPanelState(_StartOpen)

func _Toggled(open):
	print("toggled ", open)
	if open != _IsOpen:
		_IsOpen = open
		_SetVisible(open)
		toggled.emit(open)

func _SetVisible(open):
	for i in _ItemsToHide:
		get_node(i).visible = open
