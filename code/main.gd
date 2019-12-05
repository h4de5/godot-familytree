extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals

# const Tree = preload("Tree.gd")
const Tree = preload("res://code/Tree.tscn")
const Parser = preload("parser.gd")
var tree

# Called when the node enters the scene tree for the first time.
func _ready():

	var parser = Parser.new();

	tree = Tree.instance()
	tree = parser.parse(tree, "res://_familytree/Stammbaum.ged")

	if !tree._individuals.size():
		tree = parser.generateExample(tree)

#	print(tree.to_string(tree.findIndividual("I5")))
#	tree.listIndividuals()
	setPersonOfInterest("I1")


func setPersonOfInterest(uid):

#	for i in range(0, get_child_count()):
#		get_child(i).queue_free()

	if has_node("Tree"):
#		get_node("Tree").queue_free()
		remove_child(get_node("Tree"))
	tree.poi = tree.findIndividual(uid)
	add_child(tree)