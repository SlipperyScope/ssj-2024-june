extends MarginContainer

@onready var Emojis:GridSelector = %Emojis
@onready var Dances:GridSelector = %Dances
@onready var Player:DDPlayer = %DDPlayer
@onready var MusicSelector:OptionButton = %MusicSelector
@onready var _File:DikDok_dd = _NewFile()

@export var _GFX:GFX
@export var _SFX:SFX

var _Frame = 0
var _Songs = {}

func _ready():
	_File = _NewFile()
	Player.Load(_File)
	_Connect()
	_Populate("Emojis", Emojis)
	_Populate("Dances", Dances)

func SetupAudio(sfx, auxChannel):
	_SFX = sfx
	Player.SetupAudio(sfx,auxChannel)
	_PopulateMusic()

func _Connect():
	MusicSelector.item_selected.connect(_MusicSelected)
	%EmojisToggle.toggled.connect(func(s):Emojis.visible = s)
	%DancesToggle.toggled.connect(func(s):Dances.visible = s)
	Emojis.Selection.connect(_OnSelection.bind(Emojis))
	Dances.Selection.connect(_OnSelection.bind(Dances))
	Player.FrameChanged.connect(_OnFrameChange)

func _Populate(setName, panel):
	var count = _GFX.Count(setName)
	for e in count:
		var button = panel.AddButton()
		button.get_node(button._ButtonPath).Graphic = _GFX.Get(setName, e)
	panel.Select(0)

func _PopulateMusic():
	for sfx in _SFX.General:
		if sfx.Metadata.has("SongID"):
			_Songs[sfx.Metadata["SongID"]] = sfx.Name
	for id in _Songs:
		MusicSelector.add_item(_Songs[id],id)

func _OnSelection(index, panel):
	var data
	match panel:
		Emojis: data = _File.Emojis
		Dances: data = _File.Dances
	if data[_Frame] != index:
		data[_Frame] = index
		Player.ReloadFrame()

func _OnFrameChange(frame):
	print("frame changed to %s"%frame)
	_Frame = frame
	Emojis.Select(_File.Emojis[frame])
	Dances.Select(_File.Dances[frame])

func _MusicSelected(index):
	_File.SongID = index
	Player.ReloadSong()

func _NewFile():
	var file:DikDok_dd = ResourceLoader.load("res://UI/Fapps/DikDok/DikDok.dd.tres")
	file.Name = "New DikDok"
	file.SongID = 0
	file.Dances = [0,0,0,0]
	file.Emojis = [0,0,0,0]
	file.Words = [0,0,0,0]
	file.Plays = 0
	file.Likes = 0
	file.Shares = 0
	file.Date = 0
	file.FrameCount = 4
	file.BPM = 120
	return file
