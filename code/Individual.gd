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
#var column = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("im ready individual")
	#get_node("container/vbox/text").push_align(RichTextLabel.ALIGN_CENTER)
	setTitle(to_string())
	if image and imagepath:
		get_node("container/vbox/hbox/image").texture = getTexture(imagepath, image)
	else:
		get_node("container/vbox/hbox").hide()
#
	if gender.to_upper() == "M":
		get_node("container/ColorRect").color = Color(0.5, 0.6, 0.9, 1)
	elif gender.to_upper() == "W" or gender.to_upper() == "F":
		get_node("container/ColorRect").color = Color(0.9, 0.6, 0.5, 1)

# funcs used for visualization

func setScale(factor = 1):
	get_node("container").rect_scale = Vector2(factor, factor)
	
func setPosition(rect):
	rect_position = rect

func getRect():
	return Rect2(get_node("container").rect_position, get_node("container").rect_size)
func getRectAbsolute():
	return Rect2(rect_position + get_node("container").rect_position, get_node("container").rect_size)

func getTexture(path, imagename):
	var img = Image.new()
	var itex = ImageTexture.new()
	var parts = imagename.rsplit("\\",false, 1)
	image = parts[1]
	img.load("_familytree\\"+ path + "\\"+ image)
	itex.create_from_image(img)
	return itex
	
func setTitle(text):
	get_node("container/vbox/text").bbcode_text = "[center]" + text + "[/center]"

# funcs used for building upfamilytree data

func node_init(_uid, _personname, _birth, _death, _occupation, _location, _gender, _image, _imagepath):
	self.uid = _uid
	self.personname = _personname
	self.birth = _birth
	self.death = _death
	self.occupation = _occupation
	self.location = _location
	self.gender = _gender
	self.image = _image
	self.imagepath = _imagepath

func to_string():
#	return  uid.to_upper() + "\n" + personname.capitalize() + " ["+ gender.to_upper() +"]\n("+birth+" - "+death+")\n"+ occupation.capitalize() + " " + location.capitalize();
	return  personname.capitalize() + "\n("+birth+" - "+death+")\n"+ occupation.capitalize() + " " + location.capitalize();

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
