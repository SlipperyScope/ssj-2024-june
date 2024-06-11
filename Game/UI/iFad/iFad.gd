extends Node


func _ready():
	InstallFapplet("Testee", preload("res://UI/Fapplets/Testee/Testee.tscn"))
	LoadFapplet("Testee")

var Fapplets = {}
var CurrentFapp:FappData = null

class FappData:
	var Name: String
	var Ref: Fapplet
	var Running: bool
	var Icon: Texture2D

func InstallFapplet(fappName, scene):
	if(!Fapplets.has(fappName)):
		var data = FappData.new()
		data.Name = fappName
		data.Ref = scene.instantiate()
		data.Running = false
		data.Icon = Texture2D.new()
		Fapplets[fappName] = data
		%Screen.add_child(data.Ref)
		data.Ref.visible = false

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
		fapp.Ref.visible = true
	else:
		push_error("No fapplet with the name" + fappName + " installed")
