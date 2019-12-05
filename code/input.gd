extends Node2D

var mousezoom = Vector2(1,1)
var zooming = false
var mousepos = Vector2(0,0)
var mousedown = false
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

		if mousepos != Vector2(0,0):
			get_node("/root/main/Camera2D").position = mousepos
			mousepos = Vector2(0,0)
		if zooming :
			get_node("/root/main/Camera2D").zoom = mousezoom
			zooming = false

#		else:
#			get_node("Camera2D").position = boundaries.position + boundaries.size / 2

#		var zoom = get_node("Tree").getBoundaries().size / get_viewport().size
#		zoom = Vector2(max(zoom.x,zoom.y), max(zoom.x,zoom.y))
#		get_node("Camera2D").zoom = zoom * mousezoom

func _input(event):
	if event is InputEventMouseButton:
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
				mousepos = get_global_mouse_position()
#				mousepos = get_viewport().get_mouse_position()

		if event.button_index == BUTTON_RIGHT and event.is_pressed():
			mousepos = Vector2(1,1)
			mousezoom = Vector2(1,1)
			zooming = true

		if event.button_index == BUTTON_MIDDLE and current_hover_node != null:
			get_node("/root/main").setPersonOfInterest(current_hover_node.uid)
			current_hover_node = null

#	if event is InputEventMouseMotion and mousedown:
#		mousepos = get_global_mouse_position()



