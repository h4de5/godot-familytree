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


#var level = 0
var color = Color(0,0,0,0)

# for visualization
#var column = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("im ready individual")
	#get_node("container/vbox/text").push_align(RichTextLabel.ALIGN_CENTER)
	setTitle(to_string())

	if image and imagepath:
		setImage(getTexture(imagepath, image))
	else:
		get_node("container/vbox/hbox").hide()
#
	if gender.to_upper() == "M":
		color = Color(0.5, 0.6, 0.9, 1)

	elif gender.to_upper() == "W" or gender.to_upper() == "F":
		color = Color(0.9, 0.6, 0.5, 1)

	get_node("container/ColorRect").color = color

# funcs used for visualization

func setScale(factor = 1):
	get_node("container").rect_scale = Vector2(factor, factor)

func setPosition(rect):
	rect_position = rect

func getRect():
	return Rect2(get_node("container").rect_position, get_node("container").rect_size)
func getRectAbsolute():
	return Rect2(rect_position + get_node("container").rect_position, get_node("container").rect_size)


func setImage(texture):

	if texture:
		get_node("container/vbox/hbox").show()
		get_node("container/vbox/hbox/image").texture = texture
	else:
		get_node("container/vbox/hbox").hide()

func getTexture(path, imagename):
	path = path.replace("\\", "/").lstrip("./");
	imagename = imagename.replace("\\", "/");
	var parts = imagename.rsplit("/",false, 1)
	image = parts[1]

#	var basepath = ProjectSettings.globalize_path("res://")

	var filename = "_familytree/"+ path +  image

#	if ResourceLoader.exists("res://_familytree/"+ path + "/"+ image):
#		var img = Image.new()
#		var itex = ImageTexture.new()
#		img.load("res://_familytree/"+ path + "/"+ image)
#		itex.create_from_image(img)
#		return itex
#	else:
	# while running from editor - load it as resource
	if ResourceLoader.exists("res://"+ filename):
#		print("loading resource: "+ filename)
		return load("res://" + filename)
	else:
		# on web export - load it via http request
		if OS.get_name() == 'HTML5':
#			print("loading http image: "+ filename)

			var fullurl = config.familytreeServer + filename
			request.send(fullurl, '', '', "on_request_completed", self)

		else:
			# all other exports - load it as file from the same directory
			var _file = File.new()
			var doFileExists = _file.file_exists(filename)
			if doFileExists:
#				print("loading file: "+ filename)
				return load(filename)
			else:
				print("file not found: "+ filename)
	return null


# general request completion information
# use this func signature for callback methods
# call this func to get response
func on_request_completed(result, response_code, headers, body, params = []):
	#disconnect("request_completed", self, "_on_request_completed")
	if result == HTTPRequest.RESULT_SUCCESS and response_code == HTTPClient.RESPONSE_OK:

		var image = Image.new()
		var image_error = image.load_jpg_from_buffer(body)
		if image_error != OK:
			printerr("An error occurred while trying to display the image.")

		var texture = ImageTexture.new()
		texture.create_from_image(image)

		setImage(texture)

	else:
		printerr("Request failed - Code: ", result, " HTTP Status: ", response_code)


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
	var nameparts = personname.rsplit(" ", false, 1)
	return  nameparts[1].capitalize() + "\n"+ \
		nameparts[0] + "\n"+ \
 		birth +" - "+ death + "\n"+ \
		occupation.capitalize() + "\n" + \
		location.capitalize();

# highlihts on mouseover
func _on_container_mouse_entered():
	get_node("container/ColorRect").color = color * 1.3
	get_node("/root/input").current_hover_node = self

func _on_container_mouse_exited():
	get_node("container/ColorRect").color = color
	get_node("/root/input").current_hover_node = null


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

