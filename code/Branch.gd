extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var child
var parents = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setIndividuals(_child, _parents):
	if _child:
		child = _child
	if _parents:
		parents = _parents

	calcPositions()

func calcPositions():
	var parent_positions = []
	var child_positions = []
	var child_box_size

	if child:
		child_box_size = Vector2(0, child.getRect().size.y/2)
		child_positions.append(child.rect_position - child_box_size/1.5)
	else:
		child_box_size = Vector2(0, 200)
		child_positions.append(0)

	if parents[0]:
		parent_positions.append(parents[0].rect_position + child_box_size/2)
	else:
		parent_positions.append(0)

	if parents[1]:
		parent_positions.append(parents[1].rect_position + child_box_size/2)
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

	rect_position = childrenpos[0]

	if has_node("LineLeft"):

		var connector_right = get_node("LineRight")
		var connector_left = get_node("LineLeft")
		var relative_right = Vector2(0,0)
		var relative_left = Vector2(0,0)

		if parentspos[0]:
			relative_left = parentspos[0] - childrenpos[0]

		if parentspos[1]:
			relative_right = parentspos[1] - childrenpos[0]

		connector_right.width = 140
		connector_left.width = 140

		if relative_right != Vector2(0,0):
			connector_right.points = PoolVector2Array(get_points(Vector2(0, 0), relative_right))
			connector_right.show()
		else:
			connector_right.hide()

		if relative_left != Vector2(0,0):
			connector_left.points = PoolVector2Array(get_points(Vector2(0, 0), relative_left))
			connector_left.show()
		else:
			connector_left.hide()

#
#		get_node("Line2D").position = childrenpos[0]
#
#		var maxpoints = get_node("Line2D").points.size()
#
#		if parentspos[0]:
#			get_points
#			get_node("Line2D").points[0] = parentspos[0] - childrenpos[0]
#
#		if parentspos[1]:
#			get_node("Line2D").points[maxpoints-1] = parentspos[1] - childrenpos[0]
	else:

		var connector_right = get_node("ConnectorRight")
		var connector_left = get_node("ConnectorLeft")
		var relative_right = Vector2(0,0)
		var relative_left = Vector2(0,0)

		if parentspos[0]:
			relative_left = parentspos[0] - childrenpos[0]

		if parentspos[1]:
			relative_right = parentspos[1] - childrenpos[0]

		var all_polygons

		if relative_right != Vector2(0,0):
			all_polygons = get_polygons(Vector2(0, 0), relative_right)
			connector_right.polygon = PoolVector2Array(all_polygons[0])
			connector_right.uv = PoolVector2Array(all_polygons[1])
			connector_right.show()
		else:
			connector_right.hide()

		if relative_left != Vector2(0,0):
			all_polygons = get_polygons(relative_left, Vector2(0, 0))
			connector_left.polygon = PoolVector2Array(all_polygons[0])
			connector_left.uv = PoolVector2Array(all_polygons[1])
			connector_left.show()
		else:
			connector_left.hide()

func get_points(from: Vector2, to: Vector2):
	var points = []

	var step_width = 80

	var polycount = max(1, floor(from.distance_to(to) / step_width))
	step_width = floor((to-from).x / polycount)

	var new_point

	# print("from: ", from, " to: ", to, " polycount: ", polycount, " ratio: ", ratio, " thickness: ", thickness)

	randomize()

	# way from top left to top middle
	for i in range(polycount+1):
		new_point = lerp(from, to, i/polycount) + rand_vector()
		points.append(new_point)

	return points

func get_polygons(from : Vector2, to : Vector2):
	var polygon_points = []
	var uv_points = []

	var step_width = 80
	var thickness

	var polycount = max(1, floor(from.distance_to(to) / step_width))
	step_width = floor((to-from).x / polycount)

	var ratio = from.distance_to(to) / to.distance_to(from)

	thickness = clamp(abs(ratio), 0.6, 2) * sign(ratio) * 100

	var new_point

	# print("from: ", from, " to: ", to, " polycount: ", polycount, " ratio: ", ratio, " thickness: ", thickness)

	randomize()

	# way from top left to top middle
	for i in range(polycount+1):
		new_point = lerp(from, to, i/polycount) + rand_vector()
		polygon_points.append(new_point)
		uv_points.append(new_point + rand_vector(-20, 20))

	# and back from bottom middle to bottom left
	for i in range(polycount+1):
		new_point = lerp(to, from, i/polycount) + rand_vector() + Vector2(0, thickness)* sign(ratio)
		polygon_points.append(new_point)
		uv_points.append(new_point + rand_vector(-20, 20))

	return [polygon_points, uv_points]


func rand_vector(rand_min = -8, rand_max = 8):
	return Vector2(floor(rand_range(rand_min,rand_max)), floor(rand_range(rand_min,rand_max)))