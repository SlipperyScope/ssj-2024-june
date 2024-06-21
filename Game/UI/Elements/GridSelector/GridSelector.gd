class_name GridSelector extends MarginContainer

signal Selection(index)

enum ToggleMode{ToggleOne, ToggleOneOrNone, ToggleAny, NoToggle}

@export var Mode:ToggleMode = ToggleMode.ToggleOne
@export var Columns:int = 8
@export var Rows:int = 0
@export_enum("Vertical:1", "Horizontal:-1", "None:0") var Overflow:int = 1
@export var Padding:int = 8
@export var ButtonTemplate:PackedScene

@onready var Background:PanelContainer = %Background
@onready var Contents:GridContainer = %Contents

var Count:
	get: return _Buttons.size()

var _SelectedID = -1
var Selected:
	get: return _Buttons[_SelectedID] if _SelectedID >= 0 and _SelectedID < _Buttons.size() else null

var _Buttons:Array = []
var _Group:ButtonGroup

func Get(index:int): return _Buttons[index]
func Select(index:int): _Buttons[index].button_pressed = true

func AddButton(preReady:Callable = func(_btn):pass, template:PackedScene = ButtonTemplate):
	if Count >= Contents.columns * Rows:
		match Overflow:
			0: return null
			1: Rows += 1
			-1: Contents.columns += 1
	var button = template.instantiate()
	preReady.call(button)
	Contents.add_child(button)
	button.button_group = _Group
	button.toggle_mode = false if Mode == ToggleMode.NoToggle else true
	_Buttons.append(button)
	button.toggled.connect(_OnSelection.bind(Count-1))
	button.pressed.connect(_OnPressed.bind(Count-1))
	return button
	
func _ready():
	Contents.columns = Columns
	Contents.add_theme_constant_override("h_separation", Padding)
	Contents.add_theme_constant_override("v_separation", Padding)
	
	if Mode == ToggleMode.ToggleOne || Mode == ToggleMode.ToggleOneOrNone:
		_Group = ButtonGroup.new()
	if Mode == ToggleMode.ToggleOneOrNone:
		_Group.allow_unpress = true

func _OnSelection(state:bool, index): 
	if state:
		_SelectedID = index
		Selection.emit(index)

func _OnPressed(index): if Mode == ToggleMode.NoToggle: _OnSelection(true, index)
