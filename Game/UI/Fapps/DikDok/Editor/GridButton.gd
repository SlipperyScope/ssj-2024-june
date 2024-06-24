extends MarginContainer

@onready var _Underlay = $Under.get_theme_stylebox("panel") if $Under else null
@onready var _Overlay = $Over.get_theme_stylebox("panel") if $Over else null
@onready var _Texture = $Texture
@onready var _Button = $Button

@export var UnderlayUpOverDown:Array[Texture]
@export var OverlayUpOverDown:Array[Texture]

var _MouseIsOver = false
var _ButtonIsDown = false

func SetTexture(texture):
	_Texture.texture = texture

func _ready():
	_Button.mouse_entered.connect(_MouseChanged.bind(true))
	_Button.mouse_exited.connect(_MouseChanged.bind(false))
	_Button.button_down.connect(_ButtonChanged.bind(true))
	_Button.button_up.connect(_ButtonChanged.bind(false))
	_Button.toggled.connect(_ButtonChanged)
	_Underlay.texture = UnderlayUpOverDown[0]
	_Overlay.texture = OverlayUpOverDown[0]

func _MouseChanged(isOver):
	_MouseIsOver = isOver
	_UpdatePanels()

func _ButtonChanged(isDown):
	_ButtonIsDown = isDown
	_UpdatePanels()

func _UpdatePanels():
	_Underlay.texture = UnderlayUpOverDown[2] if _Button.button_pressed else (UnderlayUpOverDown[1] if _MouseIsOver else UnderlayUpOverDown[0])
	_Overlay.texture = OverlayUpOverDown[2] if _Button.button_pressed else (OverlayUpOverDown[1] if _MouseIsOver else OverlayUpOverDown[0])

class states:
	var Up
	var Over
	var Down
	func _init(up, over, down):
		Up = up
		Over = over
		Down = down
