extends Node

@onready var crunch_sound = $CrunchSound
var dragging := false
var drag_offset := Vector2i.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = DisplayServer.window_get_position() - DisplayServer.mouse_get_position()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			crunch_sound.play()
	
	if event is InputEventMouseMotion and dragging:
		DisplayServer.window_set_position(
			DisplayServer.mouse_get_position() + drag_offset
		)
