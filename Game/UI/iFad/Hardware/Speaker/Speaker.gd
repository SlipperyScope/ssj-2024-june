class_name Speaker extends Device

signal PlayStateChanged(playing:bool)

@export var MaxPolyphony:int = 8

var Playing:bool = false

var _Phones:Array[AudioStreamPlayer] = []

func Play(stream:AudioStream, spool:bool = false):
	var phone = _GetNextAvailablePhone()
	if phone:
		phone.stream = stream
		phone.play()
	elif spool:
		pass # naw

func _ready():
	for p in MaxPolyphony:
		_AddPhone()
	
func _AddPhone():
	var phone: = AudioStreamPlayer.new()
	add_child(phone)
	_Phones.append(phone)

func _GetNextAvailablePhone() -> AudioStreamPlayer:
	for phone in _Phones:
		if !phone.playing: return phone
	return null
