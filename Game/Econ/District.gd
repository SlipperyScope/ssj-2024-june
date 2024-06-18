class_name District

var Name: String = ''
var Econ: Graph = null
var Demands:Dictionary = {}

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

func TechIndustry():
    # Upgraded recipes for tech stuff
    pass

func TechArt():
    # Upgraded recipes for art stuff
    pass

func Next():
    # Call to progress the econ simulation
    pass