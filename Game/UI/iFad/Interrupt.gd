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

func _to_string():
	var id = IID.keys()[ID]
	var params: = ""
	for p in Params: params = "%s, %s"%[params,p]
	return "ID: %s with params %s and callback %s"%[id, params, Callback]
