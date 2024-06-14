@icon("res://UI/iFad/R.png")
extends Node

@export var _OSMScript:GDScript
@export var _Bloatware:Array[Manifest]

var _OSM:OSM

func _ready():
	_OSM = _OSMScript.new()
	_OSM.RegisterDevices(%Screen, %Speaker)
	add_child(_OSM)
	for fapplet in _Bloatware:
		_OSM.Install(fapplet)
	OnHomePress.call_deferred()
	%Home.pressed.connect(OnHomePress)

func OnHomePress():
	_OSM.PushInterrupt(OSM.Interrupt.Home)
