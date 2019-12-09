extends Node2D

var mousezoom = Vector2(1,1)
var zooming = false
var mousepos = Vector2(0,0)
var mousedown = false
var mouselastup = Vector2(0,0)
var mousefirstdown = Vector2(0,0)
var touchdowns = {}
var touchdistance = 0
var touchzoom = Vector2(0,0)
var delta_max = 0
var current_hover_node = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if delta_max > 0:
		delta_max -= delta

	elif has_node("/root/main/Tree"):
		delta_max = 0.01
#		print("size ", get_viewport().size)
#		print("rect_size ", get_node("Tree").rect_size)
#		print("getBoundaries ", get_node("Tree").getBoundaries())
#		var boundaries = get_node("Tree").getBoundaries()

#		if mousepos != Vector2(0,0):
		if mousepos != get_node("/root/main/Camera2D").position:
			get_node("/root/main/Camera2D").position = mousepos
		if zooming :
			get_node("/root/main/Camera2D").zoom = mousezoom
			zooming = false

#		else:
#			get_node("Camera2D").position = boundaries.position + boundaries.size / 2

#		var zoom = get_node("Tree").getBoundaries().size / get_viewport().size
#		zoom = Vector2(max(zoom.x,zoom.y), max(zoom.x,zoom.y))
#		get_node("Camera2D").zoom = zoom * mousezoom

func _input(event):
	if event is InputEventMagnifyGesture:
		print("factor of zooming: "+ str(event.factor))
		mousezoom *= event.factor
		if event.factor != 1:
			zooming = true

#	elif event is InputEventScreenDrag and touchdowns.size() >= 2:
#		touchdowns[event.index] = {pos: event.pos}
#
#		if touchdowns.size()>1:
#			var second_distance = dist()
#			if abs(touchdistance-second_distance)>10:
#				var new_zoom =Vector2(touchdistance/second_distance,touchdistance/second_distance)
#				mousezoom = new_zoom
#				zooming = true
#
##				camera.set_global_pos(node_center)
##		elif events.size()==1:
##			camera.set_global_pos(camera.get_global_pos()-event.relative_pos*camera.get_zoom()*2)
#
#
#
#	elif event is InputEventScreenTouch:
#		if event.pressed:
#			touchdowns[event.index] = {pos: event.pos}
#			if touchdowns.size()>1:
##				touchzoom = mousezoom
#				touchdistance = dist()
#
#		else:
#			touchdowns.erase(event.index)


	elif event is InputEventMouseMotion and mousedown:
#		print("mousepos: ", mousepos, " mousefirstdown: ", mousefirstdown)
		mousepos = mouselastup + (mousefirstdown - get_global_mouse_position())*2

	elif event is InputEventMouseButton:

		# get_tree().set_input_as_handled()
		if event.button_index == BUTTON_WHEEL_DOWN:
			mousezoom *= 1.1
			zooming = true
		elif event.button_index == BUTTON_WHEEL_UP:
			mousezoom /= 1.1
			zooming = true
		else:
			zooming = false

		if event.button_index == BUTTON_LEFT :
			mousedown = event.is_pressed()


			if mousedown:
				#mousepos = get_global_mouse_position()
				mousefirstdown = get_global_mouse_position()
			else:
				mousefirstdown = Vector2(0,0)
				mouselastup = mousepos
#				mousepos = get_viewport().get_mouse_position()

		if event.button_index == BUTTON_RIGHT and event.is_pressed():
			mousepos = Vector2(0,0)
			mousezoom = Vector2(1,1)
			zooming = true

		if event.button_index == BUTTON_MIDDLE and current_hover_node != null:
			get_node("/root/main").setPersonOfInterest(current_hover_node.uid)
			current_hover_node = null
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_1:

#			var image = get_viewport().get_texture().get_data()
			var viewport = get_node("/root/main/Viewport")

			var tree = get_node("/root/main/Tree")
			get_node("/root/main").remove_child(tree)


#			viewport.add_child(tree.duplicate())
			viewport.add_child(tree)
#			viewport.get_node("Camera2D").zoom = Vector2(0.1,0.1)
			var image = viewport.get_texture().get_data()
			image.flip_y()
			image.save_png("screenshot.png")

#	if event is InputEventMouseMotion and mousedown:
#		mousepos = get_global_mouse_position()



#
#var first_distance =0
#var events={}
#var percision = 10
#var current_zoom
#var maximum_zoomin = Vector2(0.5,0.5)
#var minimum_zoomout = Vector2(3,3)
#var node_center
#func _ready():
#	set_process_unhandled_input(true)
#	pass
#
#func is_zooming():
#	return events.size()>1
#
func dist():
	var first_event =null
	var result
	for event in touchdowns:
		if first_event!=null:
			result = touchdowns[event].pos.distance_to(first_event.pos)
			break
		first_event = touchdowns[event]
	return result
#
#func center():
#	var first_event =null
#	var result
#	for event in events:
#		if first_event!=null:
#			result = (map_pos(events[event].pos) + map_pos(first_event))/2
#			break
#		first_event = events[event].pos
#	return result
#
#func map_pos(pos):
#	var mtx = get_viewport().get_canvas_transform()
#	var mt = mtx.affine_inverse()
#	var p = mt.xform(pos)
#	return p
#
#func _unhandled_input(event):
#	var camera = get_node("/root/main/Camera2D")
#	if event is InputEventScreenTouch and event.is_pressed():
#		events[event.index]=event
#
#		if events.size()>1:
#			current_zoom=camera.get_zoom()
#			first_distance = dist()
#			node_center = center()
#	elif event is InputEventScreenTouch and not event.is_pressed():
#		events.erase(event.index)
#	elif event is InputEventScreenDrag :
#		events[event.index] = event
#
#		if events.size()>1:
#			var second_distance = dist()
#			if abs(first_distance-second_distance)>percision:
#				var new_zoom =Vector2(first_distance/second_distance,first_distance/second_distance)
#				var zoom = new_zoom*current_zoom
#				if zoom<minimum_zoomout and zoom>maximum_zoomin:
#					camera.set_zoom(zoom)
#				elif zoom>minimum_zoomout:
#					camera.set_zoom(minimum_zoomout)
#				elif zoom<maximum_zoomin:
#					camera.set_zoom(maximum_zoomin)
#				camera.set_global_pos(node_center)
#		elif events.size()==1:
#			camera.set_global_pos(camera.get_global_pos()-event.relative_pos*camera.get_zoom()*2)

