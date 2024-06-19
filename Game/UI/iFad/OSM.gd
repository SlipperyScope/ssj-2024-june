@icon("res://UI/iFad/OSM.ico.png")
class_name OSM extends Node

#var _GFX:GFX = ResourceLoader.load("res://UI/iFad/Graphics/Graphics.tres")
#var _AUX:AUX = ResourceLoader.load("res://UI/iFad/Audio/Audio.tres")
var _InstalledFapps:Dictionary = {}
var _FappMan:_FappManager
var _Compositor:_ScreenCompositor
var _Devices:Dictionary
var _Launcher:int = -1
var _ID:int = -1
func _NextID()->int:
	_ID += 1
	return _ID

func Install(pk:Package):
	var id: = _NextID()
	var manifest: = Manifest.new()
	var data: = FappData.new(id, pk.Name, pk.Icon, pk.Graphics)
	manifest.Name = pk.Name
	manifest.ID = id
	manifest.DisplayInLauncher = pk.Type == Fapp.Type.Fapplet
	manifest.Scene = pk.Scene
	manifest.Type = pk.Type
	manifest.Data = data
	_InstalledFapps[id] = manifest
	if _Launcher < 0 && manifest.Type == Fapp.Type.Launcher:
		_Launcher = id
		#_FappMan.Launch(manifest)

func _init(devices:Dictionary):
	_Devices = devices
	if devices.has(HomeButton): devices[HomeButton].Pressed.connect(func():_HandleInterrupt(devices[HomeButton], Interrupt.new(Interrupt.IID.Home)))
	_FappMan = _FappManager.new()
	_FappMan.FappInterrupting.connect(_HandleInterrupt)
	_Compositor = _ScreenCompositor.new(devices[Screen])

func _HandleInterrupt(sender, i:Interrupt):
	match i.ID:
		
		i.IID.GetFappList:
			i.Params[0].call(_InstalledFapps.keys())
			
		i.IID.GetFappInfo: 
			var fapp:Manifest = _InstalledFapps[i.Params[1]]
			i.Params[0].call(fapp.Name, fapp.Data.Icon, fapp.DisplayInLauncher)
			
		i.IID.FappOut:
			if _Devices[i.Params[1]] is Screen:
				var frame = _Compositor.GetFrame(sender)
				i.Params[0].call(frame)
				
		i.IID.LaunchFapp:
			var id = i.Params[1]
			var query = _FappMan.Query(id)
			if query == null: 
				query = _FappMan.Launch(_InstalledFapps[id])
				query.Instance.Notify(Notification.new(Notification.NID.Init))
				_Compositor.GetFrame(query.Instance).add_child(query.Instance)
			else:
				_Compositor.BringForward(query.Instance)
			
		i.IID.Home:
			_HandleInterrupt(self, Interrupt.new(Interrupt.IID.LaunchFapp,[null,_Launcher]))
			#_Compositor.BringForward(_FappMan.Query(_Launcher).Instance)

class _FappManager:
	signal FappInterrupting(sender:Fapp, i:Interrupt)
	
	var _FappList:Dictionary
	
	func Launch(manifest:Manifest):
		var id = manifest.ID
		if !_FappList.has(id):
			var instance:Fapp = manifest.Scene.instantiate()
			instance._Data = manifest.Data
			instance.PushInterrupt.connect(func(s,i):FappInterrupting.emit(s,i))
			var task: = _FappTask.new(id,instance)
			_FappList[id] = task
		return _FappList[id]
		
	func Query(id): return _FappList[id] if _FappList.has(id) else null
	
	class _FappTask:
		var Instance
		var ID
		var Suspended
		func _init(id, instance):
			ID = id
			Instance = instance

class _ScreenCompositor:
	signal PushInterrupt(sender, i:Interrupt)
	
	var _Frames = {}
	var _Screen:Screen
	
	var _UIOverlay
	var _AlwaysOnTop
	var _FappFrame:Control
	
	func Hide(ref):
		if _Frames.has(ref):_Frames[ref].visible = false
	
	func BringForward(ref):
		_FappFrame.move_child(_Frames[ref], -1)
	
	func GetFrame(requester):
		if requester is Fapp && !_Frames.has(requester):
			var frame = _NewFrame()
			_Frames[requester] = frame
			_FappFrame.add_child(frame)
		return _Frames[requester]
	
	func _NewFrame(): return MarginContainer.new()
		#frame.child_exiting_tree.connect
	
	func _init(screen:Screen):
		_Screen = screen
		_FappFrame = MarginContainer.new()
		screen.AddRenderSource(_FappFrame)
