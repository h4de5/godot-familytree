extends Node2D

#const Individual = preload("Individual.gd")
#const Family = preload("Family.gd")
const Individual = preload("res://Individual.tscn")
const Family = preload("res://Family.tscn")

var individuals = []
var families = []

var poi = null


# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready tree")




# used for building upfamilytree data

func addIndividual(id, personname, birth, death, occupation, location, gender):
#	var node = Individual.new();
	var node = Individual.instance();
	node.node_init(id, personname, birth, death, occupation, location, gender, "")
	individuals.append(node)

func addFamily(id, husband, wife, children, date, location):
#	var node = Family.new();
	var node = Family.instance();
	node.node_init(id, husband, wife, children, date, location)
	families.append(node)


func findIndividual(id):
	for node in individuals:
		if node.id == id:
			return node
	return null

func findFamily(id):
	for node in families:
		if node.id == id:
			return node
	return null

func findParents(id):
	for node in families:
		if node.children.has(id):
			return [findIndividual(node.husband), findIndividual(node.wife)]
	return null

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
