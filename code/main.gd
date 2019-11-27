extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals

# const Tree = preload("Tree.gd")
const Tree = preload("res://code/Tree.tscn")
const Parser = preload("parser.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready main")

#	var tree = Tree.new();
	var tree = Tree.instance()
	var parser = Parser.new();

#	tree = parser.generateExample(tree)


	tree = parser.parse(tree, "_familytree/Stammbaum.ged")


	print(tree.to_string(tree.findIndividual("I5")))

	tree.poi = tree.findIndividual("I1")

	add_child(tree)

	print("ende ready main")

var delta_max = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if delta_max > 0:
		delta_max -= delta

	elif has_node("Tree"):
		delta_max = 2
#		print("size ", get_viewport().size)
#		print("rect_size ", get_node("Tree").rect_size)
#		print("getBoundaries ", get_node("Tree").getBoundaries())
		var boundaries = get_node("Tree").getBoundaries()

		get_node("Camera2D").position = boundaries.position + boundaries.size / 2

		var zoom = get_node("Tree").getBoundaries().size / get_viewport().size
		zoom = Vector2(max(zoom.x,zoom.y), max(zoom.x,zoom.y))
		get_node("Camera2D").zoom = zoom


