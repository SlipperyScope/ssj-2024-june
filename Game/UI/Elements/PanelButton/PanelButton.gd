class_name PanelButton extends PanelContainer

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

@onready var Padding:MarginContainer = %Padding
@onready var Display:TextureRect = %Display

@onready var _Inner:BaseButton = %Inner
var _MouseIsOver:bool
var _IsToggled:bool
var _MouseIsDown:bool

var _disabled:bool = false
@export var disabled:bool :
	get: return _disabled
	set(value):
		_disabled = value
		if _Inner: _Inner.disabled = value

var _toggle_mode:bool = false
@export var toggle_mode:bool :
	get: return _toggle_mode
	set(value):
		_toggle_mode = value
		if _Inner: _Inner.toggle_mode = value

var _button_pressed:bool = false
var button_pressed:bool :
	get: return _button_pressed
	set(value):
		_button_pressed = value
		if _Inner: _Inner.button_pressed = value

var _keep_pressed_outside:bool = false
@export var keep_pressed_outside:bool :
	get: return _keep_pressed_outside
	set(value):
		_keep_pressed_outside = value
		if _Inner: _Inner.keep_pressed_outside = value

var _button_group:ButtonGroup
@export var button_group:ButtonGroup : 
	get: return button_group
	set(value):
		button_group = value 
		if _Inner: _Inner.button_group = value

@export_category("Theme")
@export var UpVariant:String
@export var DownVariant:String
@export var OverVariant:String
@export var DisabledVariant:String
@export var FocusedVariant:String

func _ready():
	_InitInner()
	_Inner.button_down.connect(_OnButtonDown)
	_Inner.button_up.connect(_OnButtonUp)
	_Inner.pressed.connect(_OnPressed)
	_Inner.toggled.connect(_OnToggle)
	_Inner.mouse_entered.connect(_OnMouseEntered)
	_Inner.mouse_exited.connect(_OnMouseExited)
	_UpdateTheme()

func _InitInner():
	_Inner.disabled = disabled
	_Inner.toggle_mode = toggle_mode
	_Inner.button_pressed = button_pressed
	_Inner.keep_pressed_outside = keep_pressed_outside
	_Inner.button_group = button_group

func _OnMouseEntered():
	_MouseIsOver = true
	_UpdateTheme()
	mouse_entered.emit()

func _OnMouseExited():
	_MouseIsOver = false
	_UpdateTheme()
	mouse_exited.emit()

func _OnButtonUp():
	_MouseIsDown = false
	_UpdateTheme()
	button_up.emit()

func _OnButtonDown():
	_MouseIsDown = true
	_UpdateTheme()
	button_down.emit()

func _OnPressed():
	pressed.emit()

func _OnToggle(state:bool):
	_IsToggled = state
	_UpdateTheme()
	toggled.emit(state)

func _UpdateTheme():
	theme_type_variation = UpVariant if (_IsToggled || _MouseIsDown || _MouseIsOver) == false else (OverVariant if _MouseIsOver && !_MouseIsDown else DownVariant)
