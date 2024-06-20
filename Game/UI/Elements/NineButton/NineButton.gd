@icon("res://UI/Elements/NineButton/NineButton.png")
class_name NineButton extends ButtonContainer

enum ButtonState{Up,Over,Down}

@onready var Content = %Content
@onready var Clickable = %Clickable
@onready var Sizer:TextureRect = %Sizer

@export var Toggle:bool = true
@export var Graphic:Texture:
	get: return Sizer.texture
	set(value): 
		_Graphic = value
		if is_node_ready(): Sizer.texture = value 
var _Graphic

@export_group("Style")
@export var _ExpandMode:TextureRect.ExpandMode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
@export var _StretchMode:TextureRect.StretchMode =TextureRect.STRETCH_KEEP_ASPECT_CENTERED
@export var CornerRadius = 8
@export var ContentMargin = 16
@export var ForegroundUnselected: ButtonTextureSet
@export var ForegroundSelected: ButtonTextureSet
@export var BackgroundUnselected: ButtonTextureSet
@export var BackgroundSelected: ButtonTextureSet

var expand_mode:TextureRect.ExpandMode:
	get: return Sizer.expand_mode
	set(value): Sizer.expand_mode = value
var stretch_mode:TextureRect.StretchMode:
	get: return Sizer.stretch_mode
	set(value): Sizer.stretch_mode = value

var _Styles
var _MouseOver:bool
var _MouseDown:bool
var _Toggled:bool

func _ready():
	Graphic = _Graphic
	expand_mode = _ExpandMode
	stretch_mode = _StretchMode
	#_ButtonPath = NodePath("./Clickable")
	super()
	_ConfigStyle()
	_ConfigButton()

func _ConfigStyle():
	_Styles = { 
		%Background:{
				true:{
					ButtonState.Up:BackgroundSelected.Up if BackgroundSelected && BackgroundSelected.Up else null,
					ButtonState.Down:BackgroundSelected.Down if BackgroundSelected && BackgroundSelected.Down else null,
					ButtonState.Over:BackgroundSelected.Over if BackgroundSelected && BackgroundSelected.Over else null,
				},
				false:{
					ButtonState.Up:BackgroundUnselected.Up if BackgroundUnselected && BackgroundUnselected.Up else null,
					ButtonState.Down:BackgroundUnselected.Down if BackgroundUnselected && BackgroundUnselected.Down else null,
					ButtonState.Over:BackgroundUnselected.Over if BackgroundUnselected && BackgroundUnselected.Over else null,
				}
			},
		%Foreground:{
				true:{
					ButtonState.Up:ForegroundSelected.Up if ForegroundSelected && ForegroundSelected.Up else null,
					ButtonState.Down:ForegroundSelected.Down if ForegroundSelected && ForegroundSelected.Down else null,
					ButtonState.Over:ForegroundSelected.Over if ForegroundSelected && ForegroundSelected.Over else null,
				},
				false:{
					ButtonState.Up:ForegroundUnselected.Up if ForegroundUnselected && ForegroundUnselected.Up else null,
					ButtonState.Down:ForegroundUnselected.Down if ForegroundUnselected && ForegroundUnselected.Down else null,
					ButtonState.Over:ForegroundUnselected.Over if ForegroundUnselected && ForegroundUnselected.Over else null,
				}
			}
		}
	
	for p in _Styles.keys():
		p.add_theme_stylebox_override("panel",StyleBoxTexture.new()) 
		p.get_theme_stylebox("panel").set_texture_margin_all(CornerRadius)
	for s in ["margin_left","margin_right","margin_top","margin_botton"]:Content.add_theme_constant_override(s,ContentMargin)
	_UpdateStyle()

func _ConfigButton():
	Clickable.mouse_entered.connect(_OnMouseEnter)
	Clickable.mouse_exited.connect(_OnMouseExit)

func _on_button_down():
	_MouseDown = true
	_UpdateStyle()
	super()
	
func _on_button_up():
	_MouseDown = false
	_UpdateStyle()
	super()
	
func _on_toggled(state:bool):
	_Toggled = state && Toggle
	_UpdateStyle()
	super(state)

func _OnMouseEnter():
	_MouseOver = true
	_UpdateStyle()
	
func _OnMouseExit():
	_MouseOver = false
	_UpdateStyle()

func _UpdateStyle():
	var state = ButtonState.Down if _MouseDown else (ButtonState.Over if _MouseOver else ButtonState.Up)
	for panel in _Styles:
		panel.get_theme_stylebox("panel").texture = _Styles[panel][_Toggled][state]
