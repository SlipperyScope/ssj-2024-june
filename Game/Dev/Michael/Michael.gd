extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var graph = Graph.new()
	graph.Element('Water')
	graph.Element('Rock')
	graph.Element('Plant')
	graph.Element('Wood')
	graph.Element('Animal')
	graph.Element('Plastic')
	graph.Element('Circuit')
	graph.Recipe("Chair: Wood[2-10] Plastic[1-5]")
	graph.Recipe("SportsDrink: Water[5-10] Rock[1-2]")
	graph.Recipe("Table: Chair[1-2]")
	graph.Recipe("Bed: Chair[2-2] Rock[2-2]")
	graph.RawCost('Bed')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass