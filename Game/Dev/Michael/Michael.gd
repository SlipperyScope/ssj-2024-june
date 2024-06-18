extends Node2D

var AllDistricts = null

func _init():
	AllDistricts = {
		"Business": District.new("Busy-ness"),
		"RichPeople": District.new("Pearl Clutchers"),
		"Arts": District.new("Artsy Farts"),
		"Industrial": District.new("Industrialites"),
		"Burbs": District.new("Burbs"),
		"Farm": District.new("Cropolis"),
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	for dist in AllDistricts.values():
		dist.Econ.RawCost('Bed')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass