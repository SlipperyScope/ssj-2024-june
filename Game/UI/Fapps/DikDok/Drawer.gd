class_name DikDok_Drawer extends MarginContainer

signal ItemSelected(index:int)

var ItemScene = preload("res://UI/Fapps/DikDok/DrawerItem.tscn")

@onready var Content = %Content

var Items:Array[DikDok_DrawerItem] = []
var Selection:int = -1

var _Source:SpriteFrames
var _SetName:String
var _Count:int

func SetContent(source:SpriteFrames, setName:String, columns:int):
	Content.columns = columns
	_Source = source
	_SetName = setName
	_Count = source.get_frame_count(setName)
	Items.resize(_Count)
	for i in _Count:
		var item = ItemScene.instantiate()
		Content.add_child(item)
		Items[i] = item
		item.Pressed.connect(SelectItem.bind(i))
	FillItems.call_deferred()

func FillItems():
	for index in _Count:
		Items[index].SetTexture(_Source.get_frame_texture(_SetName,index))

func SelectItem(index:int):
	if Selection != -1:
		Items[Selection].Selected = false
	Selection = index
	Items[index].Selected = true
	ItemSelected.emit(index)
