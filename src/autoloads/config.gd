extends Node

var familytreeFilename = ''
var familytreeDirectory = ''
var familytreeServer = ''
var personOfInterest = ''
var maxLevel = 10

var outputDirectory = ''
var outputFactor = 1

func _init():
	read_config()

func read_config():
	var config = ConfigFile.new()
	var err = config.load("settings.cfg")
	if err == OK: # if not, something went wrong with the file loading
		print("loading settings.cfg")
		#familytreeFilename = config.get_value("familytree", "filename", "Stammbaum.ged")
		familytreeFilename = config.get_value("familytree", "filename", "")
		familytreeDirectory = config.get_value("familytree", "directory", "_familytree/")
		familytreeServer = config.get_value("familytree", "server", "")
		personOfInterest = config.get_value("familytree", "poi", "I1")
		maxLevel = config.get_value("familytree", "max_level", 10)


		outputDirectory = config.get_value("output", "directory", "user://")

		outputFactor = config.get_value("output", "factor", 1)

		# Look for the display/width pair, and default to 1024 if missing
#		var screen_width = config.get_value("display", "width", 1024)
		# Store a variable if and only if it hasn't been defined yet
#		if not config.has_section_key("audio", "mute"):
#			config.set_value("audio", "mute", false)
		# Save the changes by overwriting the previous file
#		config.save("user://settings.cfg")
	else:
		printerr("missing settings.cfg - see settings.cfg.dist for an example - Error Code: "+ str(err))
