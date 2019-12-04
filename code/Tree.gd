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
		# print person of interest
		# should be 0
		var column = getFreePosition(0, 0, 0)
		poi.rect_position = calcPosition(0, column)
		add_child(poi)

		level_counts['level0'] = [0]

		renderParents(poi.uid, -1)

#		renderSiblings(poi.uid, 0)
#		renderPartners(poi.uid, 0)

#		renderChildren(poi.uid, 1)


# funcs used for visualization

func renderParents(id, level, column = 0):
	var individuals = findParents(id)
	if individuals:
		# first parent will go to the left
		var side = -1
		for individual in individuals:
			if individual:
				# get depth of current individual to find position
				var newcolumn = 0
#				newcolumn = getFreePosition(level, column, getDepth(individual.uid), side)
				var maximums = getMaxRightLeft(individual.uid)

				if side == -1:
					newcolumn = getFreePosition(level, column, maximums[0], side)
				else:
					newcolumn = getFreePosition(level, column, maximums[1], side)

				individual.rect_position = calcPosition(level, newcolumn)
				add_child(individual)
				renderParents(individual.uid, level-1, newcolumn)
				# second parent will go to the right
				side *= -1

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

# returns the next free position (to the right) on a certain level
# if current node is side -1 (husband) than it should be placed in that column, where the right-most parent element is above the childs column-1
# if current node is side +1 (wife) than it should be placed in that column, where the left-most parent element is above the child element+1
func getFreePosition(level, childpos = 0, parentdepth = 0, side = 1):
	var column = 0
	if ! level_counts.has('level'+str(level)):
		level_counts['level'+str(level)] = []
	# get max of childpos + rightest column of current level
	var basepos = childpos
	if side == 1:
		basepos = max(childpos, arrmax(level_counts['level'+str(level)]))
	# if child is at position x, parent will be depth*side
	column = basepos + parentdepth * side
	level_counts['level'+str(level)].append(column)
	return column



func calcPosition(level, column):
	# level is y position of the node
	var margin = 0

	var container = poi.getRect()
	return Vector2(
		(container.size.x * 0.8 + margin) * column,
		(container.size.y + margin) * level
	)

#	return Vector2(
#		(container.position.x + container.size.x + margin) * level_counts['level'+str(level)],
#		(container.position.y + container.size.y + margin) * level)

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

func arrmax(arr):
	if arr:
		arr.sort()
		return arr[arr.size()-1]
	else:
		return 0

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
	node.node_init(id, personname, birth, death, occupation, location, gender, '..\\icon.png', '..')
	individuals.append(node)
	return individuals.size()-1

func addFamily(id, husband, wife, children, date, location):
#	var node = Family.new();
	var node = Family.instance();
	node.node_init(id, husband, wife, children, date, location)
	families.append(node)
	return families.size()-1

# iterates through a tree to get the deepest leaf
func getDepth(uid, level = 1):
	var parents = findParents(uid)
	if parents:
#		level = level + 1
		for node in parents:
			if node:
#				level = max(level, getDepth(node.uid, level))
				level = max(level, getDepth(node.uid, level+1))
	return level

# get rightest and leftest element up the tree
# yes - rightest and leftest .. those are words now
# side = 1.. right, -1 .. left
func getMaxRightLeft(uid, currentcolumn = 0, side = 0):
	var rightest = 0
	var leftest = 0

	var parents = findParents(uid)
	if parents:
		var parent_side = 0
		for node in parents:
			if node:
				var maxrightleft

				maxrightleft = getMaxRightLeft(node.uid, currentcolumn - 1, -1)

				# husband - left .. == 0
				# wife right .. == 1
				if maxrightleft:
					leftest = max(leftest, maxrightleft[0])
					rightest = max(rightest, maxrightleft[1])
#
#				if parent_side == 0:
#					leftest = maxrightleft[0] - 1
#				else:
#					leftest = maxrightleft[0] - 1
#					rightest = getMaxRightLeft(node.uid, currentcolumn + 1, 1) + 1
			parent_side += 1
#	if side == -1:
#		return leftest
#	elif side == 1:
#		return rightest
#	else:
	return [leftest,rightest]

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
