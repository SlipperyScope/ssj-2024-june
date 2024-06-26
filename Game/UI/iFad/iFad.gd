extends Node2D

@export var _OSMScript:GDScript
@export var _Bloatware:Array[Package]

@onready var _Devices = {Screen:%Screen,HomeButton:%HomeButton,Speaker:%Speaker,Radio:%Radio}

var _OSM:OSM

func GetRadio(): return %Radio

func _ready():
		_OSM = _OSMScript.new(_Devices)
		for fapp in _Bloatware: _OSM.Install(fapp)
