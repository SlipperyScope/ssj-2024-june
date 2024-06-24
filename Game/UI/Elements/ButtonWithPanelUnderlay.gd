extends BaseButton

@export var PanelPath:NodePath
@export var Up:Texture
@export var Over:Texture
@export var Down:Texture

@export var UseToggled:bool = false
@export var Toggled_Up:Texture
@export var Toggled_Over:Texture
@export var Toggled_Down:Texture

@onready var _Style = get_node(PanelPath).get_theme_stylebox("panel")

var MouseIsOver
var ButtonIsDown 

func _ready():
	var button = self
	button.mouse_entered.connect(_MouseChanged.bind(true))
	button.mouse_exited.connect(_MouseChanged.bind(false))
	button.button_down.connect(_ButtonChanged.bind(true))
	button.button_up.connect(_ButtonChanged.bind(false))
	button.toggled.connect(_ButtonToggled)
	#button.pressed.connect(_ButtonToggled.bind(!ButtonIsDown))
	_UpdateTexture()
	
func _MouseChanged(state):
	MouseIsOver = state
	_UpdateTexture()
	
func _ButtonChanged(state):
	ButtonIsDown = state
	_UpdateTexture()

func _ButtonToggled(state):
	ButtonIsDown = state
	_UpdateTexture()

func _UpdateTexture():
	if UseToggled && button_pressed:
		_Style.texture = Toggled_Down if ButtonIsDown else (Toggled_Over if MouseIsOver else Toggled_Up)
	else:
		_Style.texture = Down if (ButtonIsDown if UseToggled else button_pressed) else (Over if MouseIsOver else Up)
