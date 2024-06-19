class_name Clock extends Device

var _Time:float = 0

func _ready():
	pass

func _process(delta):
	_Time += delta

func GetTime() -> float: return _Time

func Init():
	_Time = 0
