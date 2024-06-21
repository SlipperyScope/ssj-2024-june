@icon("res://UI/Fapps/DikDok/icon.png")
extends Fapp

func _ready():
	PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Speaker, null, 1], func(s):%Editor.SetupAudio(_Data.Sfx, s)))
