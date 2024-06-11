extends MarginContainer
class_name FappletIcon

signal pressed(fappName:String)

func _ready():
	$TextureButton.pressed.connect(func(): emit_signal("pressed",$VBoxContainer/Label.text))

func Configure(fappName: String, texture: Texture2D):
	$VBoxContainer/TextureRect.texture = texture
	$VBoxContainer/Label.text = fappName

