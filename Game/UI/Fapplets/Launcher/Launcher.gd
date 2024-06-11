extends Fapplet
class_name FappLauncher

signal LaunchFapplet(fappName: String)

var IconScene = preload("res://UI/Fapplets/Launcher/FappletIcon.tscn")
var Icons = {}

func AddFapp(fappName: String, texture: Texture2D):
	if (Icons.has(fappName)):
		push_warning("Fapplet with name " + fappName + " already installed")
		return
	var icon:FappletIcon = IconScene.instantiate()
	Icons[fappName] = icon
	icon.Configure(fappName, texture)
	%Icons.add_child(icon)
	icon.pressed.connect(onIconPressed)
	# connect button signal

func onIconPressed(fappName:String):
	emit_signal("LaunchFapplet", fappName)

func RemoveFapp(fappName: String):
	pass
