class_name ExpanderPanel extends MarginContainer

@onready var _Horizontal:VBoxContainer = %Horizontal
@onready var _Vertical:HBoxContainer = %Vertical
@onready var _Clicker:PanelButton = %Clicker
@onready var _ContentPanel:PanelContainer = %ContentPanel
@onready var _Content:MarginContainer = %Content
enum __Orientation
{
	Horizontal,
	Vertical
}
var _Orientation:__Orientation
@export_enum("Horizontal", "Vertical") 
var Orientation:int:
	get: return _Orientation 
	set(value): _Orientation = value

func _ready():
	_Clicker.mouse_entered.connect(_OnMouseOver)
	_Clicker.mouse_exited.connect(_OnMouseOut)
	_Clicker.toggled.connect(_OnButtonToggle)
	Orientation = __Orientation.Horizontal if !__Orientation else __Orientation.Vertical
	get_child(1).reparent(_Content)
	_Clicker.custom_minimum_size = get_combined_minimum_size()
	
func _OnMouseOver():
	pass

func _OnMouseOut():
	pass
	
func _OnMousePress():
	pass

func _OnButtonToggle(state:bool):
	_ContentPanel.visible = state

func Orient(direction: Orientation):
	match direction:
		__Orientation.Vertical:
			_Clicker.reparent(_Vertical)
			_ContentPanel.reparent(_Vertical)
			_Horizontal.visible = false
			_Vertical.visible = true
		__Orientation.Horizontal:
			_ContentPanel.reparent(_Horizontal)
			_Clicker.reparent(_Horizontal)
			_Horizontal.visible = true
			_Vertical.visible = false
