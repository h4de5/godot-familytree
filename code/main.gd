extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals

# const Tree = preload("Tree.gd")
const Tree = preload("res://code/Tree.tscn")
const Parser = preload("parser.gd")

var mousezoom = 1
var mousepos = Vector2(0,0)
var mousedown = false
var delta_max = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready main")
#	var tree = Tree.new();
	var tree = Tree.instance()
	var parser = Parser.new();
#	tree = parser.generateExample(tree)

	tree = parser.parse(tree, "res://_familytree/Stammbaum.ged")
	
	if !tree._individuals.size():
		tree = parser.generateExample(tree)
		
#	print(tree.to_string(tree.findIndividual("I5")))
#	tree.listIndividuals()
	tree.poi = tree.findIndividual("I1")
	add_child(tree)
	print("ende ready main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if delta_max > 0:
		delta_max -= delta

	elif has_node("Tree"):
		delta_max = 0.01
#		print("size ", get_viewport().size)
#		print("rect_size ", get_node("Tree").rect_size)
#		print("getBoundaries ", get_node("Tree").getBoundaries())
		var boundaries = get_node("Tree").getBoundaries()

		if mousepos != Vector2(0,0):
			get_node("Camera2D").position = mousepos
		else:
			get_node("Camera2D").position = boundaries.position + boundaries.size / 2

		var zoom = get_node("Tree").getBoundaries().size / get_viewport().size
		zoom = Vector2(max(zoom.x,zoom.y), max(zoom.x,zoom.y))
		get_node("Camera2D").zoom = zoom * mousezoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			mousezoom *= 1.1
		if event.button_index == BUTTON_WHEEL_UP:
			mousezoom *= 0.9
		if event.button_index == BUTTON_LEFT :
			mousedown = event.is_pressed()

			if mousedown:
				mousepos = get_global_mouse_position()
#				mousepos = get_viewport().get_mouse_position()

		if event.button_index == BUTTON_RIGHT and event.is_pressed():
			mousepos = Vector2(0,0)

#	if event is InputEventMouseMotion and mousedown:
#		mousepos = get_global_mouse_position()



