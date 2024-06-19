class_name AUX extends Resource

enum Category {
	Misc,
	UI,
	Speech,
	Sus,
	Music
}

@export_category("UI")
@export var _UI:Array[AudioData]
@export_category("Music")
@export var _Music:Array[MusicData]
@export_category("Speech")
@export var _Speech:Array[SpeechData]
@export_category("Misc")
@export var _Misc:Array[AudioData]
@export_category("Sus")
@export var _Sus:Array[AudioData]

func GetData(category:Category, index:int) -> AudioData:
	var source:Array[AudioData]
	match category:
		Category.UI:
			source = _UI
		Category.Speech:
			source = _Speech.map(func(d):d as AudioData)
		Category.Misc:
			source = _Misc
		Category.Sus:
			source = _Sus
		Category.Music:
			source = _Music.map(func(d):d as AudioData)
	return source[index]

func GetStream(category:Category, index:int) -> AudioStream: return GetData(category, index).Stream

func Count(category:Category) -> int:
	var source:Array[AudioData]
	match category:
		Category.UI:
			source = _UI
		Category.Speech:
			source = _Speech.map(func(d):d as AudioData)
		Category.Misc:
			source = _Misc
		Category.Sus:
			source = _Sus
		Category.Music:
			source = _Music.map(func(d):d as AudioData)
	return source.size()
	