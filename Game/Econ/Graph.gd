class_name Graph

var Nodes:Dictionary = {}

func Element(el: String):
    self.FindOrMake(el, EconNode.NodeType.Resource)

func Recipe(pattern: String):
    var ingrToken = RegEx.new()
    ingrToken.compile(r'(\w+)\[(\d+)-(\d+)\]')
    var tokens = pattern.split(' ')
    var name = tokens[0].substr(0, len(tokens[0])-1)
    var lamb = func (st):
        var res = ingrToken.search(st)
        if !res:
            print('Busted pattern %s' % st)
            return
        return [res.get_string(1), int(res.get_string(2)), int(res.get_string(3))]
    var ingredients = Array(tokens.slice(1)).map(lamb)
    if self.Nodes.has(pattern):
        print("There's already a %s recipe" % name)
        return

    # First make the created resource node
    var resource = self.FindOrMake(name, EconNode.NodeType.Resource)
    # Then make the recipe node
    var node = EconNode.new(pattern, EconNode.NodeType.Recipe)
    # Point the recipe at the resource
    node.AddEdge(resource, 1)
    self.Nodes[pattern] = node
    # Point ingredients at the recipe
    for i in ingredients:
        node.AddDep(
            self.FindOrMake(i[0], EconNode.NodeType.Resource),
            i[1] if i[2] - i[1] == 0 else randi() % (i[2] - i[1]) + i[1]
        )

func FindOrMake(id: String, type: EconNode.NodeType):
    if self.Nodes.has(id):
        var n = self.Nodes[id];
        if (n.Type == type):
            return n
        else:
            print('Found node but wrong type Game Jam!')
    var make = EconNode.new(id, type)
    self.Nodes[id] = make
    return make

func MinToMaxResourceIter():
    var nodes = self.Nodes.values().filter(func(n:EconNode): return n.Type == EconNode.NodeType.Resource)
    nodes.sort_custom(func(a,b): return a.MaxDistanceToRoot() > b.MaxDistanceToRoot())
    return nodes

func WalkCosts():
    for i in self.MinToMaxResourceIter():
        if i.ApproxCost.size() == 0:
            i.RawCost()

func RawCost(id: String):
    if !self.Nodes.has(id):
        print('Node "%s" not found' % id)
    else:
        return self.Nodes[id].RawCost()