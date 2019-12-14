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

	if has_node("Line2D"):
		get_node("Line2D").position = childrenpos[0]

		var maxpoints = get_node("Line2D").points.size()

		if parentspos[0]:
			get_node("Line2D").points[0] = parentspos[0] - childrenpos[0]

		if parentspos[1]:
			get_node("Line2D").points[maxpoints-1] = parentspos[1] - childrenpos[0]
	else:
		var connector = get_node("Connector")
		var relative_right
		var relative_left

		if parentspos[0]:
			relative_right = parentspos[0] - childrenpos[0]
		else:
			relative_right = childrenpos[0] + Vector2(50,-50)
		if parentspos[1]:
			relative_left = parentspos[1] - childrenpos[1]
		else:
			relative_left = childrenpos[0] + Vector2(-50,-50)

		connector.polygon

		pass
