class_name DikDok_dd extends Resource

@export var Name:String
@export var SongID:int
@export var BPM:float
@export var Dances:Array[int]
@export var Emojis:Array[int]
@export var Words:Array[int]
@export var Background:Texture
@export var Plays:int
@export var Likes:int
@export var Shares:int
@export var Date:int
@export var FrameCount:int

static var Empty:DikDok_dd:
	get: 
		
		var dd = DikDok_dd.new()
		dd.Name = "untitled"
		dd.SongID = 0
		dd.BPM = 120
		dd.FrameCount = 4
		dd.Dances = [0,0,0,0] as Array[int]
		dd.Emojis = [0,0,0,0] as Array[int]
		dd.Words = [0,0,0,0] as Array[int]
		dd.Background = null
		dd.Plays = 0
		dd.Likes = 0
		dd.Shares = 0
		dd.Date = 0
		return dd
