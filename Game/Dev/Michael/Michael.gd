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

	# Test Next and Motivations
	var a = AllDistricts["Arts"]
	a.Motivations.push_back(District.Motivate(District.MotivationType.Demand, "Bed", 1, 2, func(i): return i))

	print("============== Motivations Test =============")
	for i in range(5):
		print("S", a.Supplies)
		print("D", a.Demands)
		print(len(a.Motivations), a.Motivations)
		a.Next()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass