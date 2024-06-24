class_name ButtonGrid extends GridContainer

signal pressed(index)

@export var ButtonScene:PackedScene
@export var PathToButton:NodePath

@export var Toggles:bool = true
@export var AllowNoToggled:bool = false
@export var AllowMultiToggle:bool = false

var _Buttons = []
var _Items = []
var _Group:ButtonGroup

var Count:int:
	get: return _Buttons.size()

var Selected

func Select(index):
	if _Buttons.size():
		_Buttons[index].button_pressed = true
		_ButtonToggled(true, index)
	else: print("there are no items")

func _ready():
	if Toggles && !AllowMultiToggle:
		_Group = ButtonGroup.new()
		_Group.allow_unpress = AllowNoToggled

func AddButton() -> Control:
	var scene = ButtonScene.instantiate()
	var button:BaseButton = scene.get_node(PathToButton)
	if _Group:
		button.button_group = _Group
	button.toggle_mode = Toggles
	add_child(scene)
	if !Count:
		button.button_pressed = true
	button.pressed.connect(_ButtonPressed.bind(Count))
	button.toggled.connect(_ButtonToggled.bind(Count))
	_Items.append(scene)
	_Buttons.append(button)
	return scene

func RemoveButton() -> Control:
	_Buttons.pop_back()
	var item = _Items.pop_back()
	remove_child(item)
	return item

func _ButtonPressed(index):
	if !Toggles: _ButtonToggled(true, index)

func _ButtonToggled(state, index):
	if state:
		Selected = index
		pressed.emit(index)
