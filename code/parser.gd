extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func parse(content, tree):
#	for line in content:
#
#	pass


#func readfile(filename):
#	var file = File.new()
#	file.open("user://"+filename, File.READ)
#	var content = file.get_as_text()
#	file.close()
#	return content


func generateExample(tree):

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
	tree.addIndividual("I12", "Käthe Wimmer", "4.2.1917", "", "Landwirtin", "Innsbruck", "f")
	tree.addIndividual("I13", "Ernst Huber", "2.5.1913", "", "Landwirt", "Innsbruck", "m")

	tree.listIndividuals();

	tree.addFamily("F1", "I3", "I4", ["I1", "I2"], "27.5.2017", "Wien")
	tree.addFamily("F2", "I5", "I6", ["I3", "I9", "I10"], "", "Graz")
	tree.addFamily("F3", "I7", "I8", ["I4"], "", "Wien")
	tree.addFamily("F4", "I9", "I11", [], "", "Graz")
	tree.addFamily("F5", "I12", "I13", ["I5"], "", "Innsbruck")

	tree.listFamilies()

	print(tree.to_string(tree.findIndividual("I2")))
	print(tree.to_string(tree.findIndividual("I100")))

	print(tree.to_string(tree.findFamily("F2")))
	print(tree.to_string(tree.findFamily("F100")))

	print(tree.to_string(tree.findParents("I4")))
	print(tree.to_string(tree.findParents("I11")))

	print(tree.to_string(tree.findSiblings("I3")))
	print(tree.to_string(tree.findSiblings("I11")))

	print(tree.to_string(tree.findChildren("I3")))
	print(tree.to_string(tree.findChildren("I11")))


	tree.poi = tree.findIndividual("I3")

	return tree

func parse(tree, filename):
	var _file = File.new()
	var doFileExists = _file.file_exists(filename)

	if doFileExists:
		_file.open(filename,1)
	
		var _index = 0
		var _cursorPos
		var current_individual = null
		var current_family = null
		var current_group = null
	
	#	while !_file.eof_reached() && _index < 1000:
		while !_file.eof_reached():
			var _line = _file.get_line()
			var node_id
	
	
			if _line.substr(0,4) == "0 @I":
	
				node_id = lineval(_line, 1)
				current_individual = tree.newIndividual(node_id)
				current_family = null
	
			if _line.substr(0,4) == "0 @F":
				node_id = lineval(_line, 1)
	
				current_family = tree.newFamily(node_id)
				current_individual = null
	
			if _line.find("1 BIRT") == 0:
				current_group = "birth"
			elif _line.find("1 DEAT") == 0:
				current_group = "birth"
			elif _line.find("1 OBJE") == 0:
				current_group = "image"
			elif _line.find("1 MARR") == 0:
				current_group = "marrige"
			elif _line.find("1 ") == 0 or _line.find("0 ") == 0:
				current_group = null
	
			if current_individual != null:
	
				if _line.find("1 NAME ") == 0:
					tree.setIndividualField(current_individual, "personname", lineval(_line).replace("/","").replace("  ", " "))
				if _line.find("2 SURN ") == 0:
					pass
				if _line.find("2 GIVN ") == 0:
					pass
				if _line.find("1 OCCU ") == 0:
					tree.setIndividualField(current_individual, "occupation", lineval(_line))
				if _line.find("1 SEX ") == 0:
					tree.setIndividualField(current_individual, "gender", lineval(_line))
	
				if _line.find("2 DATE ") == 0 && current_group == "birth":
					tree.setIndividualField(current_individual, "birth", lineval(_line))
				if _line.find("2 PLAC ") == 0 && current_group == "birth":
					tree.setIndividualField(current_individual, "location", lineval(_line))
	
				if _line.find("2 DATE ") == 0 && current_group == "death":
					tree.setIndividualField(current_individual, "death", lineval(_line))
	
				if _line.find("2 FILE ") == 0 && current_group == "image":
					tree.setIndividualField(current_individual, "image", lineval(_line))
				if _line.find("3 _ALTPATH ") == 0 && current_group == "image":
					tree.setIndividualField(current_individual, "imagepath", lineval(_line))
	
	#			print(_line, " - ", current_individual, " | ",  tree.individuals[current_individual].to_string())
	
			if current_family != null:
				if _line.find("1 HUSB ") == 0:
					tree.setFamilyField(current_family, "husband", lineval(_line))
				if _line.find("1 WIFE ") == 0:
					tree.setFamilyField(current_family, "wife", lineval(_line))
				if _line.find("1 CHIL ") == 0:
					tree.setFamilyField(current_family, "children", lineval(_line))
				if _line.find("2 DATE ") == 0 && current_group == "marrige":
					tree.setFamilyField(current_family, "date", lineval(_line))
				if _line.find("2 PLAC ") == 0 && current_group == "marrige":
					tree.setFamilyField(current_family, "location", lineval(_line))
	
			_index += 1
			_cursorPos = _file.get_position()
		_file.close()
	else:
		print("cannot find file name: "+ filename)
		
	return tree
	

func lineval(line, part = 2, max_parts = 2):
	return line.split(" ", false, max_parts)[part].trim_prefix('@').trim_suffix('@')
#	return line.split(" ", false, max_parts)[part]
