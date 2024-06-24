@icon("res://UI/Fapps/DikDok/icon.png")
extends Fapp

var rng = RandomNumberGenerator.new()

enum AppState { Home, Profile, Feed, Creator }

@onready var _Gfx = _Data.Gfx
@onready var _Sfx = _Data.Sfx
@onready var _Timeline = %TimelineButtons
@onready var _Host = %DdHost

var _State = -1
var _Frame = 0
var _Playing = false
var _Time = 0
var _NextFrame = INF
var _Stream
var _File
var _Feed
var _FeedPosition

func Notify(msg):
	match msg.ID:
		msg.NID.Init:
			print("notify init")
			PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Speaker, null, 1], 
			func(s):
				_Stream = s
				print("setting stream to %s"%s)))
		msg.NID.Sleep:
			_SetPlaying(false)
		_: pass
	super(msg)

func _ready():
	_InitPlayer()
	_InitCreator()
	_InitProfile()
	_InitFeed()
	_InitNav()
	_SetState(AppState.Home)

func _InitCreator():
	_Data.Store["Creator"] = {"Temp":DikDok_dd.Empty}
	var grids = {"Emojis":[%EmojiGrid,%EmojiGridButton],"Dances":[%DanceGrid,%DanceGridButton]}
	for id in grids:
		var grid = grids[id][0]
		var button = grids[id][1]
		for i in _Gfx.Count(id) - (4 if id == "Emojis" else 0):
			var newbtn = grid.AddButton()
			newbtn.SetTexture(_Gfx.Get(id, i))
			newbtn._Button.mouse_entered.connect(_PlaySound.bind("Over"))
			newbtn._Button.pressed.connect(_PlaySound.bind("Down"))
		button.toggled.connect(func(s):grid.visible = s)
		button.mouse_entered.connect(_PlaySound.bind("Over"))
		button.pressed.connect(_PlaySound.bind("Down"))
		grid.pressed.connect(_PanelItemSelected.bind(id))
	var ss = %SongSelector
	var songs:Array[WAD] = _Sfx.Songs
	for s in songs.size() - 1:
		ss.add_item(songs[s].Name, s)
	ss.item_selected.connect(_SetSong)
	%PostButton.pressed.connect(_PostDD)
	%PostButton.mouse_entered.connect(_PlaySound.bind("Over"))
	%PostButton.pressed.connect(_PlaySound.bind("Down"))

func _PostDD():
	_Data.Store["Creator"]["Profile"]["Hand"]["DikDoks"].append(_File) 
	PushInterrupt.emit(self, Interrupt.new(Interrupt.IID.FappOut, [Radio, {DikDok_dd:_File}]))
	_LoadFile(DikDok_dd.Empty)

func _InitPlayer():
	%PPButton.toggled.connect(_SetPlaying)
	_Timeline.pressed.connect(_SetFrame)

func _InitProfile():
	var dd = DikDok_dd.Empty
	dd.FrameCount = 8
	dd.BPM = 240
	dd.Emojis = [18,12,16,17,2,6,19,7] as Array[int]
	dd.Dances = [2,3,14,15,16,17,16,17] as Array[int]
	dd.Words = [1,0,2,6,3,4,5,6] as Array[int]
	dd.SongID = 3
	dd.Plays = 69420
	dd.Likes = 9001
	dd.Shares = 1337
	_Data.Store["Creator"]["Profile"] = {
		"Hand":{
			"Pic":0,
			"Handle":"TheHand",
			"Blurb":"<User has not unlocked blurb\nBe cool - unlock blurb>",
			"DikDoks":[]
		},
		"Kusp":{
			"Pic":1,
			"Handle":"EvronKusp",
			"Blurb":"To help fight bots I have added payment tiers.\nUnlock more stuff to prove you're not a bot 🤖]\n💪🏻🤑🤑🤑🤑",
			"DikDoks": [dd]
		}
	}

func _InitFeed():
	_FeedPosition = 0
	%FeedNext.pressed.connect(_FeedButton.bind(1))
	%FeedNext.mouse_entered.connect(_PlaySound.bind("Over"))
	%FeedNext.pressed.connect(_PlaySound.bind("Down"))
	%FeedPrev.pressed.connect(_FeedButton.bind(-1))
	%FeedPrev.mouse_entered.connect(_PlaySound.bind("Over"))
	%FeedPrev.pressed.connect(_PlaySound.bind("Down"))
	pass

func _FeedButton(dir):
	match dir:
		1:
			if _FeedPosition < _Feed.size()-1:
				_FeedPosition = _FeedPosition + 1
				_SetPlaying(false)
				_LoadFile(_Feed[_FeedPosition])
				_SetPlaying(true)
		-1:
			if _FeedPosition > 0:
				_FeedPosition = _FeedPosition - 1
				_SetPlaying(false)
				_LoadFile(_Feed[_FeedPosition])
				_SetPlaying(true)
		0:
			pass

func _InitNav():
	%NavProfile.pressed.connect(_SetState.bind(AppState.Profile))
	%NavProfile.mouse_entered.connect(_PlaySound.bind("Over"))
	%NavProfile.pressed.connect(_PlaySound.bind("Down"))
	%NavProfile.pressed.connect(func():%SidePanelButton.button_pressed = false)
	%NavCreator.pressed.connect(_SetState.bind(AppState.Creator))
	%NavCreator.mouse_entered.connect(_PlaySound.bind("Over"))
	%NavCreator.pressed.connect(_PlaySound.bind("Down"))
	%NavCreator.pressed.connect(func():%SidePanelButton.button_pressed = false)
	%NavFeed.pressed.connect(_SetState.bind(AppState.Feed))
	%NavFeed.mouse_entered.connect(_PlaySound.bind("Over"))
	%NavFeed.pressed.connect(_PlaySound.bind("Down"))
	%NavFeed.pressed.connect(func():%SidePanelButton.button_pressed = false)
	%NavPanel.visible = true

func _SetState(state):
	if state == _State:
		return
	_SetPlaying(false)
	match _State:
		AppState.Creator:
			print("storing temp")
			_Data.Store["Creator"]["Temp"] = _File
	var config
	match state:
		AppState.Home:
			config = {%Host:true,%Player:true,%Creator:false,%Feed:false,%Profile:true,%Stats:true}
			%ProfilePic.texture = _Gfx.Get("Profiles",_Data.Store["Creator"]["Profile"]["Kusp"]["Pic"])
			%Blurb.text = _Data.Store["Creator"]["Profile"]["Kusp"]["Blurb"]
			_Feed = _Data.Store["Creator"]["Profile"]["Kusp"]["DikDoks"]
			%Handle.text = _Data.Store["Creator"]["Profile"]["Kusp"]["Handle"]
		AppState.Profile:
			config = {%Host:true,%Player:true,%Creator:false,%Feed:true,%Profile:true,%Stats:true}
			%ProfilePic.texture = _Gfx.Get("Profiles",_Data.Store["Creator"]["Profile"]["Hand"]["Pic"])
			%Blurb.text = _Data.Store["Creator"]["Profile"]["Hand"]["Blurb"]
			%Handle.text = _Data.Store["Creator"]["Profile"]["Hand"]["Handle"]
			_Feed = _Data.Store["Creator"]["Profile"]["Hand"]["DikDoks"]
		AppState.Feed:
			config = {%Host:true,%Player:true,%Creator:false,%Feed:true,%Profile:false,%Stats:true}
			_Feed = []
			_FeedPosition = 0
			for r in 24: _Feed.append(_GenerateRandomFeedItem())
		AppState.Creator:
			config = {%Host:true,%Player:true,%Creator:true,%Feed:false,%Profile:false,%Stats:false}
			_Feed = []
	for panel in config:
		panel.visible = config[panel]
	_State = state
	_LoadFile((_Feed[0] if _Feed.size() else DikDok_dd.Empty) if state != AppState.Creator else _Data.Store["Creator"]["Temp"])
	if _State != AppState.Creator: _SetPlaying(true)

func _SetPlaying(playing):
	if playing != _Playing:
		SetFrame(0)
		_Playing = playing
		_NextFrame = _Time + 8.0 / _File.FrameCount if playing else INF
		if playing: _Stream.play()
		else: _Stream.stop()

func _PanelItemSelected(index, id):
	var current
	match id:
		"Emojis":
			current = _File.Emojis[_Frame]
			if index != current:
				_File.Emojis[_Frame] = index
				_ReadFrame()
		"Dances":
			current = _File.Dances[_Frame]
			if index != current:
				_File.Dances[_Frame] = index
				_ReadFrame()

func _SetFrameButtons():
	var timeline = _Timeline
	var current = timeline.Count
	var count = _File.FrameCount
	timeline.columns = count
	for i in abs(current - count):
		if current < count:
			timeline.AddButton()
		else:
			timeline.RemoveButton().queue_free()

func _SetSong(id):
	var stream:AudioStreamPlayer = _Stream
	var playing = stream.playing
	var position = stream.get_playback_position()
	stream.stream = _Sfx.Songs[id].Stream
	if playing: stream.play(position)
	_File.SongID = id

func _LoadFile(dd):
	_File = dd
	dd.Plays += rng.randi_range(0,400)
	dd.Likes += rng.randi_range(0,40)
	dd.Shares += rng.randi_range(0,4)
	_SetStats()
	_SetSong(_File.SongID)
	_SetFrameButtons()
	SetFrame(0)

func _SetStats():
	%Views.text = str(_File.Plays)
	%Likes.text = str(_File.Likes)
	%Shares.text = str(_File.Shares)

func SetFrame(num):
	_Timeline.Select(num)

func _SetFrame(num):
	_Frame = num
	if _File.Emojis[_Frame] < 16 :%EmojiGrid.Select(_File.Emojis[_Frame])
	%DanceGrid.Select(_File.Dances[_Frame])
	_ReadFrame()

func _ReadFrame():
	_Host._Frame.Emoji = _Gfx.Get("Emojis", _File.Emojis[_Frame])
	_Host._Frame.Dance = _Gfx.Get("Dances", _File.Dances[_Frame])

func _GenerateRandomFeedItem() -> DikDok_dd:
	var rd = func():return rng.randi_range(0,23)
	var re = func():return rng.randi_range(0,15 + rng.randi_range(0,4))
	var dd = DikDok_dd.Empty
	dd.Name = "untitled"
	dd.SongID = rng.randi_range(0,2 + rng.randi_range(0,1))
	dd.BPM = 120
	dd.FrameCount = rng.randi_range(2,4)*2
	dd.Dances = [] as Array[int]
	for d in dd.FrameCount: dd.Dances.append(rd.call())
	dd.Emojis = [] as Array[int]
	for e in dd.FrameCount: dd.Emojis.append(re.call())
	dd.Words = [] as Array[int]
	for e in dd.FrameCount: dd.Words.append(0)
	dd.Background = null
	dd.Plays = rng.randi_range(0,69420)
	dd.Likes = rng.randi_range(0,6942)
	dd.Shares = rng.randi_range(0,694)
	dd.Date = 0
	return dd

func _process(delta):
	_Time += delta
	if (_Time >= _NextFrame):
		SetFrame((_Frame + 1) % _File.FrameCount)
		_NextFrame += 8.0 / _File.FrameCount
		if _Frame == 0:
			_Stream.play()














