class_name Fapp extends PanelContainer

signal PushInterrupt(sender:Fapp, i:Interrupt)

enum Type {
	Fapplet,
	Launcher,
	Widget
}

var _Data:FappData

func GetID():return _Data.ID

func Notify(message:Notification):
	pass
