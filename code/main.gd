extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals



# const Tree = preload("Tree.gd")
const Tree = preload("res://code/Tree.tscn")
#const Parser = preload("parser.gd")
var tree

# Called when the node enters the scene tree for the first time.
func _ready():
	# ProjectSettings.set("rendering/environment/default_clear_color", "#ffffff")
	VisualServer.set_default_clear_color(Color("ffffff"))
#	parser = Parser.new()
	tree = Tree.instance()
	# should not be part of export - use normal path
	# tree = parser.parse(tree, "res://_familytree/Stammbaum.ged")
	#tree = parser.parse(tree, "_familytree/Stammbaum.ged")
#	var stammbaum_filename = "user://_familytree/Stammbaum.ged"

	#var basepath = ProjectSettings.globalize_path("res://")
	#print ('basepath: '+ basepath)
	#if basepath == '':
	#	basepath = '/volume1/web/dev/familytree/'

	call_deferred("start_parser")
	print("Main ready ready")

#	print(tree.to_string(tree.findIndividual("I5")))
#	tree.listIndividuals()

func start_parser():
	parser.file_prepare(tree)


func setPersonOfInterest(uid):
	if has_node("Center/VBox/Tree"):
#		get_node("Tree").queue_free()
		get_node("Center/VBox").remove_child(get_node("Center/VBox/Tree"))
	tree.poi = tree.findIndividual(uid)

	if tree.poi:
		get_node("Center/VBox/Headline").bbcode_text = "[center]Ahnentafel von "+ tree.poi.getNameFormated()+ "[/center]"
		get_node("Center/VBox").add_child(tree)
	else:
		printerr("cannot find individual with id: "+ uid)