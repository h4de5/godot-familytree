extends Node2D

var id = ""
var personname = ""
var birth = ""
var death = ""
var occupation = ""
var location = ""
var gender = ""
var image = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready individual")
	get_node("RichTextLabel").text = to_string()


# used for building upfamilytree data

func node_init(id, personname, birth, death, occupation, location, gender, image):
	self.id = id
	self.personname = personname
	self.birth = birth
	self.death = death
	self.occupation = occupation
	self.location = location
	self.gender = gender
	self.image = image

func to_string():
	return "@"+ id.to_upper() + " - " + personname.capitalize() + " ["+ gender.to_upper() +"] ("+birth+" - "+death+") "+ occupation.capitalize() + " " + location.capitalize();

# example data from GEDCOM
#	0 @I17@ INDI
#	1 _UID 5234A5234B3452E24256C34635E
#	1 NAME Max /Mustermann/
#	2 SURN Mustermann
#	2 GIVN Max
#	1 SEX M
#	1 FAMC @F7@
#	1 BIRT
#	2 DATE 1 FEB 1950
#	1 OCCU Worker
#	1 OBJE
#	2 FILE C:\somefile.JPG
#	3 _ALTPATH .\Media\
#	3 FORM jpg
#	2 TITL somefile
#	1 FAMS @F41@
#	1 FAMS @F43@
#	1 FAMS @F44@
