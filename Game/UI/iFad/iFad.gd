extends Node
class_name iFad

var Fapplets = {}
var CurrentFapp:FappData = null
var Launcher:FappLauncher

func _ready():
	InstallLauncher(preload("res://UI/Fapplets/Launcher/Launcher.tscn"))
	InstallFapplet("Testee", preload("res://UI/Fapplets/Testee/Testee.tscn"))
	%Home.pressed.connect(OpenLauncher)

class FappData:
	var Name: String
	var Ref: Fapplet
	var Running: bool
	var FappIcon: Texture2D

func InstallLauncher(scene):
	# check for existing launcher
	var launcher:FappLauncher = scene.instantiate()
	var data = FappData.new()
	data.Name = "Launcher"
	data.Ref = launcher
	data.Running = false
	data.FappIcon = null
	%Screen.add_child(launcher)
	Launcher = launcher
	launcher.LaunchFapplet.connect(LoadFapplet)
	for fappData in Fapplets.values():
		launcher.AddFapp(fappData.Name, fappData.FappIcon)

func OpenLauncher():
	if (CurrentFapp != null):
		CurrentFapp.Ref.Minimize()
		CurrentFapp.Ref.visible = false
		CurrentFapp = null
		Launcher.visible = true

func InstallFapplet(fappName, scene):
	if(!Fapplets.has(fappName)):
		var data = FappData.new()
		data.Name = fappName
		data.Ref = scene.instantiate()
		data.Running = false
		data.FappIcon = data.Ref.IconTexture
		Fapplets[fappName] = data
		%Screen.add_child(data.Ref)
		data.Ref.visible = false
		if (Launcher != null):
			Launcher.AddFapp(data.Name, data.FappIcon)

func LoadFapplet(fappName):
	if (CurrentFapp != null):
		if (CurrentFapp.Name == fappName):
			return
		else:
			CurrentFapp.Ref.Minimize()
	var fapp: FappData = Fapplets[fappName]
	if (fapp != null):
		if(fapp.Running == true):
			fapp.Ref.Maximize()
		else:
			fapp.Ref.Open()
		CurrentFapp = fapp
		fapp.Running = true
		Launcher.visible = false
		fapp.Ref.visible = true
	else:
		push_error("No fapplet with the name" + fappName + " installed")
