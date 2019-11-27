extends Control

#const Individual = preload("Individual.gd")
#const Family = preload("Family.gd")
const Individual = preload("res://code/Individual.tscn")
const Family = preload("res://code/Family.tscn")

var individuals = []
var families = []
# person of interest
var poi = null

var level_counts = {}

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("im ready tree")
	if poi != null:
		add_child(poi)
		level_counts['level0'] = 0

		renderParents(poi.uid, -1)

#		renderSiblings(poi.uid, 0)
		renderPartners(poi.uid, 0)

		renderChildren(poi.uid, 1)


# funcs used for visualization

func renderParents(id, level):
	var individuals = findParents(id)
	if individuals:
		for individual in individuals:
			if individual:
				individual.rect_position = getFreePosition(level)
				add_child(individual)
				renderParents(individual.uid, level-1)

func renderChildren(id, level):
	var individuals = findChildren(id)
	if individuals:
		for individual in individuals:
			if individual:
				individual.rect_position = getFreePosition(level)
				add_child(individual)
				renderChildren(individual.uid, level+1)

func renderPartners(id, level):
	var individuals = findPartners(id)
	if individuals:
		for individual in individuals:
			if individual:
				individual.rect_position = getFreePosition(level)
				add_child(individual)
	#			renderPartners(individual.uid, level+1)

func renderSiblings(id, level):
	var individuals = findSiblings(id)
	if individuals:
		for individual in individuals:
			if individual:
				individual.rect_position = getFreePosition(level)
				add_child(individual)
	#			renderSiblings(individual.uid, level+1)


func getFreePosition(level):
	# level is y position of the node
	var margin = 40
	if ! level_counts.has('level'+str(level)):
		level_counts['level'+str(level)] = 0
	else:
		level_counts['level'+str(level)] += 1
	var container = poi.getRect()

	return Vector2(
		(container.position.x + container.size.x + margin) * level_counts['level'+str(level)],
		(container.position.y + container.size.y + margin) * level)

func getBoundaries():
	var boundaries = Rect2(0,0,0,0)
	if get_children():
		for node in get_children():
			if node is preload("Individual.gd"):
				var container = node.getRectAbsolute()
				boundaries.position.x = min(boundaries.position.x, container.position.x)
				boundaries.position.y = min(boundaries.position.y, container.position.y)
				boundaries.size.x = max(boundaries.size.x, container.position.x + container.size.x)
				boundaries.size.y = max(boundaries.size.y, container.position.y + container.size.y)


	return boundaries





# funcs used for building upfamilytree data
func newIndividual(fid):
	var node = Individual.instance();
	node.uid = fid
	individuals.append(node)
	return individuals.size()-1

func newFamily(fid):
	var node = Family.instance();
	node.fid = fid
	families.append(node)
	return families.size()-1

func setIndividualField(index, field, value):
	individuals[index][field] = value

func setFamilyField(index, field, value):
	if field == 'children':
		if !families[index][field]:
			families[index][field] = []
		families[index][field].append(value)
	else:
		families[index][field] = value

func addIndividual(id, personname, birth, death, occupation, location, gender):
#	var node = Individual.new();
	var node = Individual.instance();
	node.node_init(id, personname, birth, death, occupation, location, gender, "")
	individuals.append(node)
	return individuals.size()-1

func addFamily(id, husband, wife, children, date, location):
#	var node = Family.new();
	var node = Family.instance();
	node.node_init(id, husband, wife, children, date, location)
	families.append(node)
	return families.size()-1

func findIndividual(uid):
	for node in individuals:
		if node.uid == uid:
			return node
	return null

func findFamily(fid):
	for node in families:
		if node.fid == fid:
			return node
	return null

func findParents(id):
	for node in families:
		if node.children.has(id):
			return [findIndividual(node.husband), findIndividual(node.wife)]
	return null

func findChildren(id):
	var children = []
	for node in families:
		if node.husband == id or node.wife == id:
			if node.children:
				for child in node.children:
					children.append(findIndividual(child))
	return children

func findSiblings(id):
	var siblings = []
	var parents = findParents(id)
	if parents:
		for parent in parents:
			for node in families:
				if node.husband == parent.uid or node.wife == parent.uid:
					for child in node.children:
						if child != id and not siblings.has(findIndividual(child)):
							siblings.append(findIndividual(child))
	return siblings

func findPartners(id):
	var partners = []
	for node in families:
		if node.husband == id and node.wife:
			partners.append(findIndividual(node.wife))
		if node.wife == id and node.husband:
			partners.append(findIndividual(node.husband))
	return partners

func listIndividuals():
	for node in individuals:
		print(node.to_string())

func listFamilies():
	for node in families:
		print(node.to_string())

func to_string(node):
	if node == null:
		return null
	elif node is Array:
		var r = ""
		for n in node:
			r = r + n.to_string() + "\n"
		return r
	else:
		return node.to_string()
