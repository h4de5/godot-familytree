extends Control

var uid = ""
var personname = ""
var birth = ""
var death = ""
var occupation = ""
var location = ""
var gender = ""
var image = ""
var imagepath = ""

# for visualization
var column = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("im ready individual")
	#get_node("container/vbox/text").push_align(RichTextLabel.ALIGN_CENTER)
	get_node("container/vbox/text").bbcode_text = "[center]" + to_string() + "[/center]"
	if image and imagepath:
		get_node("container/vbox/hbox/image").texture = getTexture(imagepath, image)

# funcs used for visualization

func getRect():
	return Rect2(get_node("container").rect_position, get_node("container").rect_size)
func getRectAbsolute():
	return Rect2(rect_position + get_node("container").rect_position, get_node("container").rect_size)

func getTexture(path, image):
	var img = Image.new()
	var itex = ImageTexture.new()
	var parts = image.rsplit("\\",false, 1)
	image = parts[1]
	img.load("_familytree\\"+ path + "\\"+ image)
	itex.create_from_image(img)
	return itex

# funcs used for building upfamilytree data

func node_init(uid, personname, birth, death, occupation, location, gender, image, imagepage):
	self.uid = uid
	self.personname = personname
	self.birth = birth
	self.death = death
	self.occupation = occupation
	self.location = location
	self.gender = gender
	self.image = image
	self.imagepage = imagepage

func to_string():
	return  uid.to_upper() + "\n" + personname.capitalize() + " ["+ gender.to_upper() +"]\n("+birth+" - "+death+")\n"+ occupation.capitalize() + " " + location.capitalize();

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
#	2 FILE C:\Media\somefile.JPG
#	3 _ALTPATH .\Media\
#	3 FORM jpg
#	2 TITL somefile
#	1 FAMS @F41@
#	1 FAMS @F43@
#	1 FAMS @F44@
