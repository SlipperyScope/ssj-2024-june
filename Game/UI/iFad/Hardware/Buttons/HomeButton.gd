class_name HomeButton extends Device

signal Pressed

@onready var Clicker:BaseButton = %Clicker

func _ready():
	Clicker.pressed.connect(func():Pressed.emit())
