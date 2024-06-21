extends Fapp

func Notify(message):
	super(message)
	match message.ID:
		Notification.NID.Init:
			_PlaySound("")
		Notification.NID.Wake:
			_PlaySound("")
