class_name EconNode

enum NodeType {
    Resource,
    Recipe
}

var From:Dictionary = {}
var To:Dictionary = {}
var Type:NodeType = NodeType.Resource
var ID:String = ''
var ApproxCost:Dictionary = {}

var _maxDistanceToRoot:int = -1
var _minDistanceToRoot:int = -1

func IsRoot():
    return self.From.size() == 0

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

func MaxDistanceToRoot():
    # memoize
    if self._maxDistanceToRoot != -1:
        return self._maxDistanceToRoot

    # calculate
    var maxDist = 0
    if self.IsRoot():
        self._maxDistanceToRoot = 0
    else:
        for i in self.From.keys():
            maxDist = max(maxDist, i.MaxDistanceToRoot())
        self._maxDistanceToRoot = maxDist if self.Type == NodeType.Recipe else maxDist + 1

    return self._maxDistanceToRoot

func MinDistanceToRoot():
    # memoize
    if self._minDistanceToRoot != -1:
        return self._minDistanceToRoot

    # calculate
    var minDist = 10000
    if self.IsRoot():
        self._minDistanceToRoot = 0
    else:
        for i in self.From.keys():
            minDist = min(minDist, i.MinDistanceToRoot())
        self._minDistanceToRoot = minDist if self.Type == NodeType.Recipe else minDist + 1

    return self._minDistanceToRoot

# Cost of all immediate dependencies
func DirectCost():
    var tally = {}
    var recipe = self.From.keys()[randi() % self.From.size()]
    for i in recipe.From.keys():
        tally[i.ID] = recipe.From[i]
    return tally

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
    self.ApproxCost = tally
    return tally
