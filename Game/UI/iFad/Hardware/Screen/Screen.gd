class_name Screen extends Device

@onready var _Renderer = %Display

var _Source

func GetRenderSource(): return _Source

func AddRenderSource(control):
	#if _Source: _Renderer.remove_child(_Source)
	#_Source = control
	_Renderer.add_child(control)

func RemoveRenderSource(control)->bool:
	for child in get_children():
		if child is Control:
			_Renderer.remove_child(child)
			return true
	return false
