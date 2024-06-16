class_name GridSelector extends MarginContainer

var ItemScene: = preload("res://UI/Elements/GridSelector/Item.tscn")

signal ElementSelected(element:Control)

@export var MultiSelect:bool = false
@export var Size:Vector2i = Vector2i(4,4)
@export var AllowOverflow:bool = true
@export var Scrollable:bool = true
@export_category("Theme")
@export var BG:String = "Light"
@export var Over:String = "Over"
@export var Up:String = "Up"
@export var Down:String = "Down"

@onready var Background:PanelContainer = %Background
@onready var Contents:GridContainer = %Contents

var _Items:Array[GridSelector_Item] = []


var _Group:ButtonGroup = ButtonGroup.new()

func _ready():
	Contents.columns = Size.x
	_Group.pressed.connect(_OnSelection)
	pass

func AddItem(texture:Texture2D):
	var item:GridSelector_Item = ItemScene.instantiate()
	Contents.add_child(item)
	item.Content.Display.texture = texture
	item.Content.button_group = _Group
	_Items.append(item)
	
func _OnSelection(button:BaseButton):
	var buttons = _Items.map(func(item): return item.Content._Inner)
	ElementSelected.emit(buttons.find(button))
	
func Select(index:int):
	if index < _Items.size():
		_Items[index].Content.button_pressed = true
