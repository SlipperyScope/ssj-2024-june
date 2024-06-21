class_name Interrupt

var ID
var Params
var Callback

func _init(id:IID, params:Array = [], callback = null):
	ID = id
	Params = params
	Callback = callback

enum IID
{
	FappOut,
	FappIn,
	GetGFX,
	GetSFX,
	GetFappList,
	GetFappInfo,
	LaunchFapp,
	Home
}
