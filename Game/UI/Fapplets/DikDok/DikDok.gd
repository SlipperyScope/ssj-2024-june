extends Fapplet


func _ready():
	%FrameButtons/Button01.pressed.connect(FrameButtonPressed.bind(1))
	%FrameButtons/Button02.pressed.connect(FrameButtonPressed.bind(2))
	%FrameButtons/Button03.pressed.connect(FrameButtonPressed.bind(3))
	%FrameButtons/Button04.pressed.connect(FrameButtonPressed.bind(4))
	
	%EmojiSelector.visible = false
	%EmojiButton.toggled.connect(EmojiButtonToggled)
	
func FrameButtonPressed(number:int):
	print("buton %s pressed" %number)
	
func EmojiButtonToggled(state:bool):
	%EmojiSelector.visible = state
