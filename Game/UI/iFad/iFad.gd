@icon("res://UI/iFad/R.png")
extends Node

@export var _PreInstalled:Array[Manifest] = []

var Fapps: Array[OSM.FappInfo] = [] # Dictionary?
var Launcher: OSM.FappInfo

func _ready():
	for fapp in _PreInstalled:
		DownloadFapp(fapp)
	Open(Launcher.Manifest.ID)

func DownloadFapp(fapp:Manifest, autoInstall:bool = true):
	if (Fapps.any(func(info:OSM.FappInfo): info.Manifest.ID == fapp.ID)):
		push_warning("Could not download %s because a fapp already exists with that ID (%s)" % fapp.Name, fapp.ID)
		return
	var info = OSM.FappInfo.new()
	info.Manifest = fapp
	Fapps.append(info)
	if fapp.Type == OSM.FappType.Launcher:
		Launcher = info
	if autoInstall:
		InstallFapp(fapp.ID)

func InstallFapp(id:int):
	var info: OSM.FappInfo
	for fapp:OSM.FappInfo in Fapps:
		if fapp.Manifest.ID == id:
			info = fapp
			break
	if info == null:
		push_warning("Fapp ID %s not found" % id)
		return
	var inst:Fapplet = info.Manifest.Scene.instantiate()
	info.Instance = inst
	%Screen.add_child(inst)
	info.Installed = true
	inst.visible = false
	if Launcher != null:
		(Launcher.Instance).UpdateFappList(Fapps)

func Open(id:int):
	for fapp in Fapps:
		if (fapp.Manifest.ID == id):
			fapp.Instance.visible = true
		elif (fapp.Active):
			Minimize(fapp.Manifest.ID)

func Minimize(id:int):
	for fapp in Fapps:
		if (fapp.Manifest.ID == id && fapp.Active):
			fapp.Active = false
			fapp.Instance.visible = false
			break

#
#var Fapplets = {}
#var CurrentFapp:FappData = null
#var Launcher:FappLauncher
#
#func _ready():
	#InstallLauncher(preload("res://UI/Fapplets/Launcher/Launcher.tscn"))
	#InstallFapplet("Testee", preload("res://UI/Fapplets/Testee/Testee.tscn"))
	#InstallFapplet("DikDok", preload("res://UI/Fapplets/DikDok/DikDok.tscn"))
	#%Home.pressed.connect(OpenLauncher)
#
#class FappData:
	#var Name: String
	#var Ref: Fapplet
	#var Running: bool
	#var FappIcon: Texture2D
#
#func InstallLauncher(scene):
	## check for existing launcher
	#var launcher:FappLauncher = scene.instantiate()
	#var data = FappData.new()
	#data.Name = "Launcher"
	#data.Ref = launcher
	#data.Running = false
	#data.FappIcon = null
	#%Screen.add_child(launcher)
	#Launcher = launcher
	#launcher.LaunchFapplet.connect(LoadFapplet)
	#for fappData in Fapplets.values():
		#launcher.AddFapp(fappData.Name, fappData.FappIcon)
#
#func OpenLauncher():
	#if (CurrentFapp != null):
		#CurrentFapp.Ref.Minimize()
		#CurrentFapp.Ref.visible = false
		#CurrentFapp = null
		#Launcher.visible = true
#
#func InstallFapplet(fappName, scene):
	#if(!Fapplets.has(fappName)):
		#var data = FappData.new()
		#data.Name = fappName
		#data.Ref = scene.instantiate()
		#data.Running = false
		#data.FappIcon = data.Ref.IconTexture
		#Fapplets[fappName] = data
		#%Screen.add_child(data.Ref)
		#data.Ref.visible = false
		#if (Launcher != null):
			#Launcher.AddFapp(data.Name, data.FappIcon)
#
#func LoadFapplet(fappName):
	#if (CurrentFapp != null):
		#if (CurrentFapp.Name == fappName):
			#return
		#else:
			#CurrentFapp.Ref.Minimize()
	#var fapp: FappData = Fapplets[fappName]
	#if (fapp != null):
		#if(fapp.Running == true):
			#fapp.Ref.Maximize()
		#else:
			#fapp.Ref.Open()
		#CurrentFapp = fapp
		#fapp.Running = true
		#Launcher.visible = false
		#fapp.Ref.visible = true
	#else:
		#push_error("No fapplet with the name" + fappName + " installed")
##/
