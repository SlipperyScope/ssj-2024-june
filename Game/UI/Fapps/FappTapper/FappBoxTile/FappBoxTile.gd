extends ButtonContainer

@onready var _Button = %NineButton
@onready var _Name = %Label

@export var Graphic:Texture:
	get: return _Button.Graphic
	set(value): _Button.Graphic = value

@export var Name:String:
	get: return _Name.text
	set(value): _Name.text = value
