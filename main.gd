extends Node2D

# a Tree contains several families
# each family has husband, wife and children
# each of those are individuals

# const Tree = preload("Tree.gd")
const Tree = preload("res://Tree.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready main")

#	var tree = Tree.new();
	var tree = Tree.instance()

	tree.addIndividual("I1", "David Müller", "28.6.2016", "", "", "Wien", "m")
	tree.addIndividual("I2", "Jakob Müller", "4.2.2019", "", "", "Wien", "m")
	tree.addIndividual("I3", "Andreas Müller", "16.7.1984", "", "Angestellter", "Graz", "m")
	tree.addIndividual("I4", "Franziska Meier", "1.5.1984", "", "Buchhalterin", "Wien", "f")
	tree.addIndividual("I5", "Gabriele Huber", "7.8.1957", "", "Angestellte", "Innsbruck", "f")
	tree.addIndividual("I6", "Ernst Müller", "5.12.1955", "", "Angestellter", "Graz", "m")
	tree.addIndividual("I7", "Martha Dorfer", "12.2.1950", "", "Hausfrau", "Wien", "f")
	tree.addIndividual("I8", "Josef Meier", "1.3.1950", "31.3.1996", "Arbeiter", "Wien", "m")
	tree.addIndividual("I9", "Magdalena Müller", "11.11.1989", "", "Angestellte", "Graz", "f")
	tree.addIndividual("I10", "Johannes Müller", "3.10.1992", "", "Student", "Graz", "m")
	tree.addIndividual("I11", "Bernd Weber", "3.9.1981", "", "Angestellter", "Graz", "m")

	tree.listIndividuals();

	tree.addFamily("F1", "I3", "I4", ["I1", "I2"], "27.5.2017", "Wien")
	tree.addFamily("F2", "I5", "I6", ["I3", "I9", "I10"], "", "Graz")
	tree.addFamily("F3", "I7", "I8", ["I4"], "", "Wien")
	tree.addFamily("F4", "I9", "I11", [], "", "Graz")

	tree.listFamilies()

	print(tree.to_string(tree.findIndividual("I2")))
	print(tree.to_string(tree.findIndividual("I100")))

	print(tree.to_string(tree.findFamily("F2")))
	print(tree.to_string(tree.findFamily("F100")))

	print(tree.to_string(tree.findParents("I4")))
	print(tree.to_string(tree.findParents("I11")))


	tree.poi = tree.findIndividual("I1")


	add_child(tree)

	print("ende ready main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
