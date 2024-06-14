extends PanelContainer

signal pressed

var UpStyle:StyleBoxFlat
var OverStyle:StyleBoxFlat
var DownStyle:StyleBoxFlat

var MouseOver:bool
var MouseDown:bool

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
		add_theme_stylebox_override("panel", UpStyle)
	
func OnDown():
	MouseDown = true
	add_theme_stylebox_override("panel", DownStyle)

func OnUp():
	MouseDown = false
	if(MouseOver):
		OnOver()
	else:
		OnOut()
