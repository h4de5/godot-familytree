extends Control

#const Individual = preload("Individual.gd")
#const Family = preload("Family.gd")
const Individual = preload("res://src/Individual2.tscn")
const Family = preload("res://src/Family.tscn")
const Branch = preload("res://src/Branch.tscn")

var _individuals = []
var _families = []
# person of interest
var poi = null
# elements to be moved to the center after tree is done
var move_to_center = []

var level_counts = {}

# just for the current tree
var _poi_tree = []
var _matrix = {}


func _enter_tree():
	if poi != null:
		print("Rendering tree for Person: "+ poi.uid)
		
		# build up tree based on poi (person of interest)
		# go up all parents (e.g. left first)
		# add all persons to family list
		# go through the list, and add all children to the list
		# for each item, set level
		# render out each item per level
		
		iterateParents(poi)
		
		print("Number of families "+ String(len(_families)))
		print("Number of individuals "+ String(len(_individuals)))
		print("Number of poi tree "+ String(len(_poi_tree)))
		
		poi.setPosition(Vector2(0,0))
		add_child(poi)
		_matrix["0"] = 1
		
		
		renderPoiTree()
		var column = 0
		var leftright = []
		
		for node in _poi_tree:
			if node.uid == poi.uid:
				continue
			
			if String(node.level) in _matrix:
				_matrix[String(node.level)] += 1
			else:
				_matrix[String(node.level)] = 1
				
			column = 0
			# man go left, woman go right
			if node.gender == 'M':
				leftright = getMaxRightLeft(node.uid, node.level, -1)
				column = leftright[0]
			else:
				leftright = getMaxRightLeft(node.uid, node.level, 1)
				column = leftright[1]
			
				
			node.setPosition(Vector2(column* 500, node.level * 700))
#			node.setPosition(Vector2(_matrix[String(node.level)]* 500, node.level * 700))
			add_child(node)
			
#
#
#		var column = getFreePosition(0, 0, 0)
#		poi.setPosition(calcPosition(0, column))
#		poi.setScale( 1 )
#		poi.setLevel(0)
#		add_child(poi)
#		# elements, that should be moved to the center of the tree
#		# after alle other elements has been placed
#		move_to_center.append(poi)
#
#		# partner of poi goes to the right
#		# renderPartners(id, level, column, side, scale):
#		renderPartners(poi.uid, 0, 0, 1, 1)
#
#		# siblings of poit goes to the left
#		# renderSiblings(id, level, column, side):
#		renderSiblings(poi.uid, 0, 0, -1)
#
#		level_counts['level0'] = [0]
#
#		# render parents and grandparents
#		# renderParents(child, level, column = 0):
#		renderParents(poi, -1)

func _exit_tree():
	for i in range(get_child_count()-1, -1, -1):
		# if we free everything
		# they will not be added to the individuals list anymore
		# because parser is only called once
		# get_child(i).queue_free()
		remove_child(get_child(i))
	level_counts = {}
	_matrix = {}
	move_to_center = []
	rect_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Tree is ready")




# funcs used for visualization

func getBoundaries():
	return Rect2(-2000,-2000,4000,4000)
	
	
func renderPoiTree():
	
	pass

# funcs used for building up familytree data

func iterateParents(node, level = 0, offset = 0):
	# add your self to the tree
	node.level = level
	if not node in _poi_tree:
		_poi_tree.append(node)
	# find parents
	var parents = findParents(node.uid)
	# recursive through parents
	if parents:
		for parent in parents:
			if parent:
				# todo: hier müsste man der function mitgeben
				# auf welche seite (wife, husband) man gerade iteriert
				# und je nach dem einen +/- versatz von 0 mit zählen
				# poi:0, vater versatz:-1, mutter:+1,
				# vater-vater versatz:-2, vater-mutter: 0
#				if parent.husband == node.uid:
				iterateParents(parent, level - 1, offset - 1)
#				elif parent.wife == node.uid:
#					iterateParents(parent, level - 1, offset + 1)
				
	iterateChildren(node, level)


func iterateChildren(node, level = 0, ancestors_level = 0):
	node.level = level
	if node.ancestors < ancestors_level:
		node.ancestors = ancestors_level
	if not node in _poi_tree:
		_poi_tree.append(node)
	var children = findChildren(node.uid)
	if children:
		for child in children:
			if child:
				iterateChildren(child, level + 1, ancestors_level + 1)

# funcs used for building up familytree data
func newIndividual(iid: String):
	var node = Individual.instance()
	node.uid = iid
	_individuals.append(node)
	return _individuals.size()-1

func newFamily(fid: String):
	var node = Family.instance()
	node.fid = fid
	_families.append(node)
	return _families.size()-1

func setIndividualField(index: int, field: String, value):
	# do not overwrite exisiting values
	if _individuals[index][field] == '':
		_individuals[index][field] = value
	# set name of the element in scene-tree
	if field == 'personname':
		_individuals[index].name = 'Individual '+ value

func setFamilyField(index: int, field: String, value):
	if field == 'children':
		if !_families[index][field]:
			_families[index][field] = []
		_families[index][field].append(value)
	else:
		_families[index][field] = value

func addIndividual(id: String, personname: String, birth, death, occupation, location, gender):
#	var node = Individual.new()
	var node = Individual.instance()
	#node.node_init(id, personname, birth, death, occupation, location, gender, '..\\icon.png', '..')
	node.node_init(id, personname, birth, death, occupation, location, gender, '', '')
	_individuals.append(node)
	return _individuals.size()-1

func addFamily(id: String, husband: String, wife: String, children, date, location):
#	var node = Family.new()
	var node = Family.instance()
	node.node_init(id, husband, wife, children, date, location)
	_families.append(node)
	return _families.size()-1

# iterates through a tree to get the deepest leaf
func getDepth(uid: String, level: int = 1):
	if abs(level) >= config.maxLevel:
		return level

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
# side = 1..right, -1..left
func getMaxRightLeft(uid: String, level: int = 0, side: int = 0):
	var rightest = 0
	var leftest = 0

	if abs(level) >= config.maxLevel:
		return [leftest,rightest]

	var parents = findParents(uid)
	if parents:
		var parent_side = -1
		for node in parents:
			if node:
				var maxrightleft

				maxrightleft = getMaxRightLeft(node.uid, level - 1)

				# husband - left .. == 0
				# wife right .. == 1

				# woop woop - thats it
				if parent_side == -1:
					leftest = min(leftest,maxrightleft[0] - maxrightleft[1] + parent_side)
#					rightest = max(rightest,maxrightleft[1] - maxrightleft[0] + parent_side)
				else:
#					leftest = min(leftest,maxrightleft[0] - maxrightleft[1] + parent_side)
					rightest = max(rightest,maxrightleft[1] - maxrightleft[0] + parent_side)


			parent_side *= -1

	var siblings = findSiblings(uid)
	if side == -1 and siblings.size() * -1 < leftest:
		print("level: ", level, " leftest old: ", leftest)
		leftest = min(siblings.size() * -1, leftest) - 5
		print("leftest new: ", leftest)


	if side == 1 and siblings.size() > rightest:
		print("level: ", level, " rightest old: ", rightest)
		rightest = max(siblings.size(), rightest)
		print("rightest new: ", rightest)

	return [leftest,rightest]

func findIndividual(uid: String):
	for node in _individuals:
		if node.uid == uid:
			return node
	return null

func findFamily(fid: String):
	for node in _families:
		if node.fid == fid:
			return node
	return null

func findParents(id: String):
	for node in _families:
		if node.children.has(id):
			return [findIndividual(node.husband), findIndividual(node.wife)]
	return null

func findChildren(id: String):
	var children = []
	for node in _families:
		if node.husband == id or node.wife == id:
			if node.children:
				for child in node.children:
					children.append(findIndividual(child))
	return children

func findSiblings(id: String):
	var siblings = []
	var parents = findParents(id)
	if parents:
		for parent in parents:
			if parent:
				for node in _families:
					if node.husband == parent.uid or node.wife == parent.uid:
						for child in node.children:
							if child != id and not siblings.has(findIndividual(child)):
								siblings.append(findIndividual(child))
	return siblings

func findPartners(id: String):
	var partners = []
	for node in _families:
		if node.husband == id and node.wife:
			partners.append(findIndividual(node.wife))
		if node.wife == id and node.husband:
			partners.append(findIndividual(node.husband))
	return partners

func listIndividuals():
	for node in _individuals:
		print(node.to_string())

func listFamilies():
	for node in _families:
		print(node.to_string())

func to_strings(node):
	if node == null:
		return null
	elif node is Array:
		var r = ""
		for n in node:
			r = r + n.to_string() + "\n"
		return r
	else:
		return node.to_string()
