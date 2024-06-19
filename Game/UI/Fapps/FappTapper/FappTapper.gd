class_name FappTapper extends Fapp

func _GetFappList(resultCallback): PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.GetFappList, [resultCallback]))
func _GetFappInfo(resultCallback, id): PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.GetFappInfo, [resultCallback, id]))
func _LaunchFapp(resultCallback, id): PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.LaunchFapp, [resultCallback, id]))

@export var test:int
@onready var _FappGrid:GridSelector = %FappGrid
var _Fapps:Array
var _Screen:Control

func Notify(message:Notification):
	if (message.ID == message.NID.Init): _Initialize()

func _Initialize():
	_GetFappList(_AddFapps)

func _AddFapps(list:Array):
	for i in list:
		_GetFappInfo(func(name, icon, display):
			if display: _Fapps.append(_FappInfo.new(i,name,icon)), i)

func _ready():
	for fapp in _Fapps: 
		var tile = _FappGrid.AddButton()
		tile.Graphic = fapp.Icon
		tile.Name = fapp.Name
	_FappGrid.Selection.connect(_SelectFapp)

func _SelectFapp(index):
	_LaunchFapp(func(success): if !success: _LaunchFailed.call(), _Fapps[index].ID)

func _LaunchFailed():
	print("launch failed")
	pass

class _FappInfo:
	var ID
	var Name
	var Icon
	func _init(id,name,icon):
		ID = id
		Name = name
		Icon = icon
