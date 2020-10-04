extends Control

var keep_parent
var keep_camera
var keep_scene
var viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prepare(scene_to_capture : Node, visible_rect : Rect2, current_viewport: Viewport, current_tree : SceneTree, factor = 0.5):
#			var image = get_viewport().get_texture().get_data()
	viewport = get_node("ViewportContainer/Viewport")

#	var tree = get_node(scene_parent)

	#get_node("/root/main").remove_child(tree)
#	get_tree().change_scene(

	# keep the parent node
	keep_parent = scene_to_capture.get_parent()
#	keep_camera = current_viewport.get_camera()
	keep_scene = scene_to_capture

	# remove capture node from parent
	keep_parent.remove_child(scene_to_capture)

	# add the capture node to the new viewport
	viewport.add_child(scene_to_capture)

#	var duplicated = scene_to_capture.duplicate(DUPLICATE_USE_INSTANCING | DUPLICATE_SCRIPTS)
#	if duplicated is Control:

	# reset position
	if scene_to_capture is Control:
		scene_to_capture.rect_position = Vector2(0,0)
	else:
		scene_to_capture.position = Vector2(0,0)

	# position the camera
	viewport.get_node("Camera2D").position = visible_rect.position + visible_rect.size/2
	viewport.get_node("Camera2D").zoom = Vector2(1/factor, 1/factor)

	# enlarge the viewport to the to be visible rect
	viewport.size = visible_rect.size * factor

	# make camera current for the screenshot
	viewport.get_node("Camera2D").make_current()
	#call_deferred("capture")
#
#	yield(current_tree,"idle_frame")
#	yield(current_tree,"idle_frame")
#	yield(current_tree,"idle_frame")
#	yield(current_tree,"idle_frame")
#
###			get_tree().change_scene_to(Screenshot)
##
#	capture("screenshot.png")
	#current_tree.remove_child(self)

func cleanup():
	get_parent().remove_child(self)

func capture(filename = "screenshot.png"):
	# wait 2 frames
#	yield(get_tree(),"idle_frame")
#	yield(get_tree(),"idle_frame")
#	yield(current_viewport, 'render_completed')


#			viewport.get_node("Camera2D").zoom = Vector2(0.1,0.1)

	# take screenshot from viewport
	var image = viewport.get_texture().get_data()

	# flip it because it needs to be flipped
	image.flip_y()
	# save it as png
	image.save_png(filename)

	# reverse changes to the scene
	viewport.remove_child(keep_scene)
	keep_parent.add_child(keep_scene)

	viewport.get_node("Camera2D").clear_current()

	# give back current camera
#	keep_camera.make_current()
