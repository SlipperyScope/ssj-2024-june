class_name District

enum MotivationType {
    Supply,
    Demand
}

static func Motivate(type:MotivationType, resource: String, magnitude:int, duration:int, decay: Callable):
    return {
        "Type": type,
        "Resource": resource,
        "Magnitude": magnitude,
        "Duration": duration,
        "Decay": decay,
    }

var Name: String = ''
var Econ: Graph = null

# Mappings of all resource types to an int
var Demands:Dictionary = {}
var Supplies:Dictionary = {}

# Every tick, all motivations are applied to this economy
# A motivation is a dictionary containing the following keys:
#   1. Type [enum] (supply or demand)
#   2. Resource [string] (how much to change value this tick)
#   2. Magnitude [int] (how much to change value this tick)
#   3. Decay [func(int): int] (how much to change the magnitude this tick)
#   4. Duration [uint] (how many ticks before the motivation self destructs)
var Motivations = [
    District.Motivate(MotivationType.Supply, "Water", 1, -1, func(i): return i),
    District.Motivate(MotivationType.Supply, "Animal", 5, 3, func(i): return i-1)
]

func _init(name:String):
    self.Name = name
    self.Econ = Graph.new()
    self.Econ.Element('Water')
    self.Econ.Element('Rock')
    self.Econ.Element('Plant')
    self.Econ.Element('Wood')
    self.Econ.Element('Animal')
    self.Econ.Element('Plastic')
    self.Econ.Element('Circuit')
    self.Econ.Recipe("Chair: Wood[2-10] Plastic[1-5]")
    self.Econ.Recipe("SportsDrink: Water[5-10] Rock[1-2]")
    self.Econ.Recipe("Table: Chair[1-2]")
    self.Econ.Recipe("Bed: Chair[2-2] Rock[2-2]")

    # Initialize demands dict
    for n in self.Econ.Nodes.keys():
        if self.Econ.Nodes[n].Type == EconNode.NodeType.Resource:
            self.Demands[n] = 0
            self.Supplies[n] = 0

func TechIndustry():
    # Upgraded recipes for tech stuff
    pass

func TechArt():
    # Upgraded recipes for art stuff
    pass

func Next():
    # Call to progress the econ simulation
    var toRemove = []
    for m in self.Motivations:
        # Update supply/demand
        var dict = self.Supplies if m["Type"] == MotivationType.Supply else self.Demands
        dict[m["Resource"]] = max(0, dict[m["Resource"]] + m["Magnitude"])

        # Update motivation
        if m["Duration"] != -1:
            m["Duration"] -= 1
            if m["Duration"] == 0:
                toRemove.push_back(m)
                continue
        m["Magnitude"] = m["Decay"].call(m["Magnitude"])

    for r in toRemove:
        self.Motivations.remove_at(self.Motivations.find(r))