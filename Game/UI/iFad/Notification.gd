class_name Notification

var ID:NID
var Params

enum NID{
	Init,
	Sleep,
	Wake,
	Close
}

func _init(id:NID, params:Array = []):
	ID = id
	Params = params
