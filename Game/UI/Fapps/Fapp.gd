class_name Fapp extends PanelContainer

signal PushInterrupt(sender:Fapp, i:Interrupt)

func _PlaySound(name) : PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Speaker, _Data.Sfx.GetWadByName(name).Stream]))

enum Type {
	Fapplet,
	Launcher,
	Widget
}

var _Data:FappData

func GetID():return _Data.ID

func Notify(message:Notification):
	match message.ID:
		Notification.NID.Init:
			PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Screen]))
