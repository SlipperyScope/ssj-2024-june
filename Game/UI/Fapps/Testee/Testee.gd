extends Fapp

func _ready():
	%Gumbk.mouse_entered.connect(_PlayOver)
	%Gumbk.mouse_exited.connect(_StopSounds)
	%Gumbk.button_down.connect(_PlayDown)

func _StopSounds():
	$Over.stop()
	$Down.stop()
	
func _PlayOver():
	_StopSounds()
	$Over.play()
	
func _PlayDown():
	_StopSounds()
	$Down.play()

func Notify(what:Notification):
	match what:
		Notification.NID.Init:
			PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Screen]))
