extends Control

var id = ""
var husband = ""
var wife = ""
var children = []
var date = ""
var location = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready family")



# funcs used for building upfamilytree data

func node_init(id, husband, wife, children, date, location):
	self.id = id
	self.husband = husband
	self.wife = wife
	self.children = children
	self.date = date
	self.location = location


func to_string():
	return "@"+ id.to_upper() + " "+ husband.to_upper() +" and "+ wife.to_upper() +" ["+ date + " at "+ location.capitalize() + "] have " + PoolStringArray(children).join(", ")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# example data from GEDCOM
#	0 @F7@ FAM
#	1 HUSB @I14@
#	1 WIFE @I15@
#	1 CHIL @I2@
#	1 MARR
#	2 DATE 31 JAN 1954
#	1 CHIL @I16@
#	1 CHIL @I17@
#	0 @F41@ FAM
#	1 HUSB @I17@
#	1 WIFE @I105@
#	1 CHIL @I20@
#	1 CHIL @I21@
#	1 MARR Y
#	0 @F43@ FAM
#	1 HUSB @I17@
#	1 WIFE @I106@
#	1 CHIL @I22@
#	1 MARR Y
#	1 CHIL @I107@
#	0 @F44@ FAM
#	1 HUSB @I17@
#	1 WIFE @I108@
#	1 CHIL @I19@
#	1 MARR Y