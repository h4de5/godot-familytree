extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals



# const Tree = preload("Tree.gd")
const Tree = preload("res://src/Tree.tscn")
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
	if has_node("Center/VBox/TreeContainer/Tree"):
#		get_node("Tree").queue_free()
		get_node("Center/VBox/TreeContainer").remove_child(get_node("Center/VBox/TreeContainer/Tree"))
	tree.poi = tree.findIndividual(uid)

	if tree.poi:
		get_node("Center/VBox/Center/Headline").bbcode_text = "[center]Ahnentafel von "+ tree.poi.getNameFormated()+ "[/center]"
		#get_node("Center/VBox/Headline").text = "[center]Ahnentafel von "+ tree.poi.getNameFormated()+ "[/center]"
		get_node("Center/VBox/TreeContainer").add_child(tree)
		call_deferred("update_tree_size")
	else:
		printerr("cannot find individual with id: "+ uid)

func update_tree_size():


	var rect = tree.getBoundaries()

	var tree_node = get_node("Center/VBox/TreeContainer/Tree")

	# should be x variable
	var moving_by = 0

	if tree_node.move_to_center.size():
		print("correcting ", tree_node.move_to_center.size(), " elements")
		for node in tree_node.move_to_center:
			if node is preload("res://src/Individual.gd"):
#				print("moving Individual ", node.personname)
				if moving_by == 0:
					moving_by = rect.size.x/2 - node.rect_position.x + rect.position.x
				node.rect_position.x += moving_by
			elif node is preload("res://src/Branch.gd"):
#				print("moving branch ", node.parents)
				yield(get_tree(),"idle_frame")
				node.setIndividuals(null, null)
#			else:
#				print("moving unknown node ", node.name)

	print("calculated rect size: ", rect.size)
	print("calculated rect position: ", rect.position.abs())

	position = Vector2(0,0)
	get_node("Center").rect_position = Vector2(0,0)
	yield(get_tree(),"idle_frame")

	get_node("Center").rect_min_size.x = rect.size.x
	yield(get_tree(),"idle_frame")

	get_node("Center/VBox").rect_min_size.x = rect.size.x
	yield(get_tree(),"idle_frame")

	var fontsize = max(rect.size.x / 40, 150)
	get_node("Center/VBox/Center/Headline").rect_min_size.x = rect.size.x
	get_node("Center/VBox/Center/Headline").rect_min_size.y = fontsize * 1.1
	yield(get_tree(),"idle_frame")

	# does not work
	# get_node("Center/VBox/Headline").get_font('font').size = 200
	# see: https://godotengine.org/qa/42430/changing-font-size-of-theme-or-control-at-runtime
	# var font = get_node("Center/VBox/Headline").get_font("string_name", "normal_font")
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/Medici Text.ttf")
	dynamic_font.size = fontsize
	dynamic_font.use_filter = true
	dynamic_font.use_mipmaps = true
	get_node("Center/VBox/Center/Headline").set("custom_fonts/normal_font", dynamic_font)
	yield(get_tree(),"idle_frame")

	get_node("Center/VBox/Center/Headline").bbcode_text += ""
	yield(get_tree(),"idle_frame")


	get_node("Center/Background").rect_min_size = rect.grow(200).grow_individual(0, fontsize*2, 0, 0 ).size
	yield(get_tree(),"idle_frame")

	#get_node("Center/VBox/Center").rect_position = rect.position
	#get_node("Center/VBox/Center").rect_position = Vector2(0,0)
	#yield(get_tree(),"idle_frame")

	get_node("Center/VBox/TreeContainer").rect_min_size = rect.size
	yield(get_tree(),"idle_frame")

	get_node("Center/VBox/TreeContainer/Tree").rect_position = rect.position.abs()
	yield(get_tree(),"idle_frame")
