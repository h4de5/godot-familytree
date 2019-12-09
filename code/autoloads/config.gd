extends Node

var familytreeFilename = ''
var familytreeDirectory = ''
var familytreeServer = ''

func _init():
	read_config()

func read_config():
	var config = ConfigFile.new()
	var err = config.load("res://settings.cfg")
	if err == OK: # if not, something went wrong with the file loading
		print("loading settings.cfg")
		familytreeFilename = config.get_value("familytree", "filename", "Stammbaum.ged")
		familytreeDirectory = config.get_value("familytree", "directory", "_familytree/")
		familytreeServer = config.get_value("familytree", "server", "")

		# Look for the display/width pair, and default to 1024 if missing
#		var screen_width = config.get_value("display", "width", 1024)
		# Store a variable if and only if it hasn't been defined yet
#		if not config.has_section_key("audio", "mute"):
#			config.set_value("audio", "mute", false)
		# Save the changes by overwriting the previous file
#		config.save("user://settings.cfg")
	else:
		printerr("missing settings.cfg - see settings.cfg.dist for an example")