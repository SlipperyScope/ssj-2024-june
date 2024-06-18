class_name EconNode

enum NodeType {
    Resource,
    Recipe
}

var From:Dictionary = {}
var To:Dictionary = {}
var Type:NodeType = NodeType.Resource
var ID:String = ''

func _init(id:String, type: NodeType):
    self.ID = id
    self.Type = type

func AddEdge(to: EconNode, weight: int):
    # Verify that to is a different node type
    if to == self:
        print("Can't add edge to self")
        return
    if to.Type == self.Type:
        print("Can't add edge from recipe to recipe or from resource to resource")
        return
    # Add/update edge to self.To and add edge to to.From
    self.To[to] = weight
    to.From[self] = weight

func AddDep(from: EconNode, weight: int):
    # Verify that to is a different node type
    if from == self:
        print("Can't add edge to self")
        return
    if from.Type == self.Type:
        print("Can't add edge from recipe to recipe or from resource to resource")
        return
    # Add/update edge to self.To and add edge to to.From
    self.From[from] = weight
    from.To[self] = weight

func RemoveEdge(to: EconNode):
    To.erase(to)
    to.From.erase(self)

# For each resource node, choose 1 recipe node (which results in a sub-tree from the dag)
# func ReciTree():
#    var root = self


# Cost of all dependencies boiled down to resources with no deps
func RawCost():
    var tally = {}
    var queue = [[1, self]]
    while len(queue):
        var el = queue.pop_front()
        var w = el[0]
        var n = el[1]
        if n.Type == NodeType.Recipe:
            for i in n.From.keys():
                queue.push_back([w*n.From[i], i])
        else:
            var keys = n.From.keys()
            if len(keys) > 0:
                queue.push_back([w, keys[randi() % len(keys)]])
            else:
                if !tally.has(n.ID):
                    tally[n.ID] = 0
                tally[n.ID] += w
    print(tally)
    return tally
