extends Fapp

func _ready():
	%Gumbk.mouse_entered.connect(func():PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut,[Speaker, _Data.Sfx.GetWadByName("Inhale").Stream])))
	%Gumbk.button_down.connect(func():PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut,[Speaker, _Data.Sfx.GetWadByName("Doot").Stream])))

func Notify(message:Notification):
	super(message)
