extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setIndividuals(child, parents):
	var parent_positions = []
	var child_positions = []
	var child_box_size

	if child:
		child_box_size = Vector2(0, child.getRect().size.y/2)
		child_positions.append(child.rect_position - child_box_size)
	else:
		child_box_size = Vector2(0, 200)
		child_positions.append(0)

	if parents[0]:
		parent_positions.append(parents[0].rect_position + child_box_size)
	else:
		parent_positions.append(0)

	if parents[1]:
		parent_positions.append(parents[1].rect_position + child_box_size)
	else:
		parent_positions.append(0)

	setPosition(child_positions, parent_positions)


func setPosition(childrenpos, parentspos):

	if !childrenpos[0]:
		if parentspos[0] and parentspos[1]:
			childrenpos[0] = parentspos[0] + (parentspos[0] - parentspos[1])/2
		else:
			printerr("cannot render branch without parents or children")
			return false

	get_node("Line2D").position = childrenpos[0]

	var maxpoints = get_node("Line2D").points.size()

	if parentspos[0]:
		get_node("Line2D").points[0] = parentspos[0] - childrenpos[0]

	if parentspos[1]:
		get_node("Line2D").points[maxpoints-1] = parentspos[1] - childrenpos[0]
