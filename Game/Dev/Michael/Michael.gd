extends Node2D

var AllDistricts = null

# Econ prefers to combine materials as much as possible
func GrowthMax(dist:District):
	print("\n\nMax ", dist.Name)
	print("Supplies ", dist.Supplies)
	var iter = dist.Econ.MinToMaxResourceIter().filter(func(n: EconNode): return !n.IsRoot())
	iter.reverse()
	for n in iter:
		# Try to make all the things (if supply > demand)
		var cost = n.DirectCost()
		print("Trying to make a %s" % n.ID)
		for i in cost.keys():
			print(" - %s %s (Have %s, Demand %s)" % [cost[i], i, dist.Supplies[i], dist.Demands[i]])
		dist.BuildMax(n.ID, cost)

# Econ prefers to combine materials to just intermediate materials
func GrowthMid(dist:District):
	print("\n\nMid ", dist.Name)
	print("Supplies ", dist.Supplies)
	var iter = dist.Econ.MinToMaxResourceIter().filter(func(n:EconNode): return n.MaxDistanceToRoot() == 1)
	iter.reverse()
	for n in iter:
		# Try to make all the things (if supply > demand)
		var cost = n.DirectCost()
		print("Trying to make a %s" % n.ID)
		for i in cost.keys():
			print(" - %s %s (Have %s, Demand %s)" % [cost[i], i, dist.Supplies[i], dist.Demands[i]])
		dist.BuildMax(n.ID, cost)

# Econ will reluctantly combine materials if they have enough surplus
func GrowthMeh(dist:District):
	print("\n\nMeh", dist.Name)

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

	for i in range(5):
		self.allNext()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
