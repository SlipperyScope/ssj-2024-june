extends Fapp

func _ready():
	%Gumbk.mouse_entered.connect(func():PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut,[Speaker, _Data.Sfx.GetWadByName("General", "Inhale").Stream])))
	%Gumbk.button_down.connect(func():PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut,[Speaker, _Data.Sfx.GetWadByName("General", "Doot").Stream])))

func Notify(message:Notification):
	super(message)
