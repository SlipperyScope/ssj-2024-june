@icon("res://UI/iFad/OSM.ico.png")
class_name OSM extends Node

var _SFX:SFX = ResourceLoader.load("res://UI/iFad/Audio/SFX.tres")

var _InstalledFapps:Dictionary = {}
var _FappMan:_FappManager
var _ScreenCom:_ScreenCompositor
var _Devices:Dictionary
var _Launcher:int = -1
var _ID:int = -1
func _NextID()->int:
	_ID += 1
	return _ID

func Install(pk:Package):
	var id: = _NextID()
	var manifest: = Manifest.new()
	var data: = FappData.new(id, pk.Name, pk.Icon, pk.Graphics, pk.Audio)
	manifest.Name = pk.Name
	manifest.ID = id
	manifest.DisplayInLauncher = pk.Type == Fapp.Type.Fapplet
	manifest.Scene = pk.Scene
	manifest.Type = pk.Type
	manifest.Data = data
	manifest.RunInBackground = pk.RunInBackground
	_InstalledFapps[id] = manifest
	if _Launcher < 0 && manifest.Type == Fapp.Type.Launcher:
		_Launcher = id
		#_FappMan.Launch(manifest)

func _PlayOnFirstPress(speaker, button):
	speaker.Play(_SFX.GetWadByName("Hohaw").Stream)
	button.Pressed.disconnect(_PlayOnFirstPress)
		
func _init(devices:Dictionary):
	_Devices = devices
	if devices.has(HomeButton): 
		var button = devices[HomeButton]
		button.Pressed.connect(func():_HandleInterrupt(button, Interrupt.new(Interrupt.IID.Home)))
		if devices.has(Speaker): button.Pressed.connect(_PlayOnFirstPress.bind(devices[Speaker],button))
	_FappMan = _FappManager.new()
	_FappMan.FappInterrupting.connect(_HandleInterrupt)
	_ScreenCom = _ScreenCompositor.new(devices[Screen])

func _HandleInterrupt(sender, i:Interrupt):
	match i.ID:
		
		i.IID.GetFappList:
			i.Callback.call(_InstalledFapps.keys())
			
		i.IID.GetFappInfo: 
			var fapp:Manifest = _InstalledFapps[i.Params[0]]
			i.Callback.call(fapp.Name, fapp.Data.Icon, fapp.DisplayInLauncher)
			
		i.IID.FappOut:
			var deviceID = i.Params[0]
			if _Devices.has(deviceID):
				var device = _Devices[deviceID]
				match deviceID:
					Screen:
						if sender is Fapp:
							var id = sender.GetID()
							_ScreenCom.GetFrame(id, _InstalledFapps[id].Type).add_child(sender)
						else:
							push_warning("I don't know what to do with %s"%sender)
					Speaker:
						if i.Params.size() == 3 && i.Params[2]:
							i.Callback.call(device.Play(i.Params[1], true))
						else: 
							device.Play(i.Params[1])
					_: push_warning("device %s drivers not installed"%device)
			else:
				push_warning("device % does not exist"%deviceID)
			
		i.IID.LaunchFapp:
			var id = i.Params[0]
			var running
			for rId in _FappMan.GetRunning():
				if rId == id:
					running = true
				else:
					if !_InstalledFapps[rId].RunInBackground:
						_FappMan.Suspend(rId)
					_ScreenCom.Hide(rId)
			if running:
				if _FappMan.IsSleeping(id):
					_FappMan.Resume(id)
				_ScreenCom.Show(id)
			else:
				_FappMan.Launch(_InstalledFapps[id])

		i.IID.Home:
			if _InstalledFapps.has(_Launcher):
				_HandleInterrupt(self, Interrupt.new(Interrupt.IID.LaunchFapp, [_Launcher]))
			else:
				push_warning("No launcher installed")
		
		_: push_warning("Did not handle %s"%i.ID)

###
class _FappManager:
	signal FappInterrupting(sender:Fapp, i:Interrupt)
	
	var _FappList:Dictionary
	
	func Launch(manifest:Manifest):
		var id = manifest.ID
		if !IsRunning(id):
			var instance:Fapp = manifest.Scene.instantiate()
			instance._Data = manifest.Data
			instance.PushInterrupt.connect(func(s,i):FappInterrupting.emit(s,i))
			_FappList[id] = _FappTask.new(id,instance)
			instance.Notify(Notification.new(Notification.NID.Init))
		else:
			if IsSleeping(id): Resume(id)
	
	func GetRunning(): return _FappList.keys()
	
	func Suspend(id): 
		if _FappList.has(id):
			_FappList[id].Suspended = true
			_FappList[id].Instance.Notify(Notification.new(Notification.NID.Sleep))
		else:
			push_warning("Why are you trying to suspend fapp %, it's not running"%id)
	
	func Resume(id):
		if _FappList.has(id):
			_FappList[id].Suspended = false
			_FappList[id].Instance.Notify(Notification.new(Notification.NID.Wake))
		else:
			push_warning("Why are you trying to resume fapp %, it's not running"%id)
	
	func Exit(id):
		if _FappList.has(id):
			_FappList[id].Instance.Notify(Notification.new(Notification.NID.Close))
		else:
			push_warning("Why are you trying to exit fapp %, it's not running"%id)
		return null
	
	func IsRunning(id): return _FappList.has(id)
	func IsSleeping(id): return _FappList.has(id) && _FappList[id].Suspended
	func Query(id): return _FappList[id] if _FappList.has(id) else null
	
	class _FappTask:
		var Instance
		var ID
		var Suspended = false
		func _init(id, instance):
			ID = id
			Instance = instance

###
class _ScreenCompositor:
	signal PushInterrupt(sender, i:Interrupt)
	
	var _Frames = {}
	var _Screen:Screen
	
	var _UIOverlay
	var _AlwaysOnTop
	var _FappletFrame:Control
	var _Launcher:Control
	
	func Hide(id):
		_Frames[id].Frame.visible = false
	
	func Show(id):
		var data = _Frames[id]
		var frame = data.Frame
		if frame.visible == false: frame.visible = true
		data.Layer.move_child(frame, -1)
	
	func Has(id): return _Frames.has(id)
	
	func GetFrame(id, type):
		if Has(id):
			return _Frames[id].Frame
		else:
			var layer = _GetLayer(type)
			var frame = _NewFrame()
			var data = _FrameData.new(frame, layer)
			_Frames[id] = data
			layer.add_child(frame)
			return frame
	
	func _NewFrame(): return MarginContainer.new()
		#frame.child_exiting_tree.connect
	
	func _GetLayer(type):
		match type:
			Fapp.Type.Fapplet:
				return _FappletFrame
			Fapp.Type.Launcher:
				return _Launcher
			_: push_warning("Fapp type %s not implemented"%type)
		return null
		
	func _init(screen:Screen):
		_Screen = screen
		_FappletFrame = MarginContainer.new()
		_FappletFrame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_Launcher = MarginContainer.new()
		_Launcher.mouse_filter = Control.MOUSE_FILTER_IGNORE
		screen.AddRenderSource(_Launcher)
		screen.AddRenderSource(_FappletFrame)
		
	class _FrameData:
		var Frame:MarginContainer
		var Layer:MarginContainer
		func _init(frame, layer):
			Frame = frame
			Layer = layer
