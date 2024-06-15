extends PanelContainer

signal pressed

var UpStyle:StyleBoxFlat
var OverStyle:StyleBoxFlat
var DownStyle:StyleBoxFlat

var MouseOver:bool
var MouseDown:bool
var Selected:bool:
	set(value):
		_Selected = value
		OnOut() if !MouseOver else OnOver()
	get:
		return _Selected
var _Selected:bool = false

func _ready():
	var style = StyleBoxFlat.new()
	style.set_corner_radius_all(4)
	style.bg_color = Color.SILVER
	UpStyle = style
	
	style = StyleBoxFlat.new()
	style.set_corner_radius_all(4)
	style.bg_color = Color.DODGER_BLUE
	OverStyle = style
	
	style = StyleBoxFlat.new()
	style.set_corner_radius_all(4)
	style.bg_color = Color.ROYAL_BLUE
	DownStyle = style
	
	OnOut()
	
	$TextureButton.mouse_entered.connect(OnOver)
	$TextureButton.mouse_exited.connect(OnOut)
	$TextureButton.button_down.connect(OnDown)
	$TextureButton.button_up.connect(OnUp)
	$TextureButton.pressed.connect(func():pressed.emit())

func OnOver():
	MouseOver = true
	if (!MouseDown):
		add_theme_stylebox_override("panel", OverStyle)
	
func OnOut():
	MouseOver = false
	if (!MouseDown):
		add_theme_stylebox_override("panel", UpStyle if !Selected else DownStyle)
	
func OnDown():
	MouseDown = true
	add_theme_stylebox_override("panel", DownStyle)

func OnUp():
	MouseDown = false
	if(MouseOver):
		OnOver()
	else:
		OnOut()
