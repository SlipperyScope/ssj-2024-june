extends Node2D

var AllDistricts = null

# Econ prefers to combine materials as much as possible
func GrowthMax(dist:District):
	print("Max", dist.Name)

# Econ prefers to combine materials to just intermediate materials
func GrowthMid(dist:District):
	print("Mid", dist.Name)

# Econ will reluctantly combine materials if they have enough surplus
func GrowthMeh(dist:District):
	print("Meh", dist.Name)

# Econ will never grow things
func GrowthNone(_dist:District):
	pass

func _init():
	AllDistricts = {
		"Business": District.new("Busy-ness", GrowthMax),
		"RichPeople": District.new("Pearl Clutchers", GrowthNone),
		"Arts": District.new("Artsy Farts", GrowthMid),
		"Industrial": District.new("Industrialites", GrowthMid),
		"Burbs": District.new("Burbs", GrowthMeh),
		"Farm": District.new("Cropolis", GrowthNone),
	}

func allNext():
	for dist in self.AllDistricts.values():
		dist.Next()
# Called when the node enters the scene tree for the first time.
func _ready():
	for dist in self.AllDistricts.values():
		dist.Econ.RawCost('Bed')

	# Test Next and Motivations
	var a = self.AllDistricts["Arts"]
	a.Motivations.push_back(District.Motivate(District.MotivationType.Demand, "Bed", 1, 2, func(i): return i))

	print("============== Motivations Test =============")
	for i in range(5):
		# print("S", a.Supplies)
		# print("D", a.Demands)
		# print(len(a.Motivations), a.Motivations)
		self.allNext()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
