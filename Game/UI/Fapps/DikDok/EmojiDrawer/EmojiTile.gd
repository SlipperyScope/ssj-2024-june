class_name EmojiTile extends Control

signal Pressed

func _ready():
	%Button.pressed.connect((func():Pressed.emit()))

func SetTexture(texture:Texture2D):
	%Button.texture_normal = texture 
