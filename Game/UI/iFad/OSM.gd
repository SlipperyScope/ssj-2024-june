@icon("res://UI/iFad/OSM.ico.png")
class_name OSM extends Node

var OS_Graphics:SpriteFrames = ResourceLoader.load("res://UI/iFad/Graphics/Graphics.tres")

signal FappListUpdated()
func OnFappListUpdated():
	FappListUpdated.emit()

var _Screen:PanelContainer
var _Speaker:AudioStreamPlayer
var _Fapps:Dictionary = {}
var _NextID:int
var _Launcher:int
var _Current:int

func _GetNextID():
	var next:int = _NextID + 1
	_NextID = next
	return next

func RegisterDevices(screen:PanelContainer, speaker:AudioStreamPlayer):
	_Screen = screen
	_Speaker = speaker

enum Msg {
	Initialize,
	Open,
	Close,
	Minimize,
	Maximize
}

class MsgData:
	pass

enum FappType {
	Fapplet,
	Launcher,
	Widget
}

enum Interrupt {
	Home,
	Back
}

class FappInfo:
	var Manifest:Manifest
	var Instance:Fapp
	var Running:bool
	var Active:bool
	var Data:Dictionary

func Install(fapp:Manifest):
	var info:FappInfo = FappInfo.new()
	info.Manifest = fapp
	var id = _GetNextID()
	if _Current == 0: _Current = 1
	_Fapps[id] = info
	if fapp.Type == FappType.Launcher:
		if (_Launcher != 0):
			Uninstall(_Launcher)
		_Launcher = id
	elif fapp.Type == FappType.Fapplet:
		OnFappListUpdated.call_deferred()
	var instance = fapp.Scene.instantiate() as Fapp
	instance._OSM = self
	info.Instance = instance
	instance.visible = false
	_Screen.add_child(instance)

func Uninstall(id:int):
	if _Fapps.has(id):
		var fapp:FappInfo = _Fapps[id]
		_Fapps.erase(id)
		fapp.Instance.queue_free()
		if _Launcher == id:
			_Launcher = 0

func PushInterrupt(id:Interrupt):
	match id:
		Interrupt.Home:
			if _Launcher != 0 && _Current != _Launcher:
				_Display(_Launcher)
		Interrupt.Back:
			pass

func _Minimize(id:int):
	_Fapps[id].Instance.visible = false

func _Display(id:int):
	if _Current != id:
		_Fapps[id].Instance.visible = true
		_Minimize(_Current)
		_Current = id

func GetFapplets() -> Dictionary:
	var fapplets:Dictionary = {}
	for key in _Fapps.keys():
		if _Fapps[key].Manifest.Type == FappType.Fapplet:
			fapplets[key] = _Fapps[key]
	return fapplets
