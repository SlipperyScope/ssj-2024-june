class_name DikDok_DrawerItem extends MarginContainer

signal Pressed

var Selected:bool:
	set(value):
		if value != _Selected:
			_Selected = value
			SetGlow(value)
	get:
		return _Selected
var _Selected:bool = false

@onready var Content:TextureRect = %Content
@onready var ClickArea:BaseButton = %Button
@onready var Glow:PanelContainer = %Glow

func SetTexture(texture:Texture2D):
	Content.texture = texture

func _ready():
	ClickArea.mouse_entered.connect(SetGlow.bind(true))
	ClickArea.mouse_exited.connect(SetGlow.bind(false))
	ClickArea.pressed.connect(func(): Pressed.emit())

func SetGlow(state:bool):
	Glow.self_modulate = Color.WHITE if state || Selected else Color.TRANSPARENT
