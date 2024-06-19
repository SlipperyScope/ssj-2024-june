class_name Interrupt

var ID
var Params

func _init(id:IID, params:Array = []):
	ID = id
	Params = params

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
