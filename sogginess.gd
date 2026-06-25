extends Node3D

@onready var fry = $Fry
var soggy_factor := 0.0
var sogginess_rate := 0.00015

func _process(delta):
	fry.rotate_y(delta * 1.0)
	
	if soggy_factor >= 1.0:
		return
	
	soggy_factor = min(soggy_factor + sogginess_rate * delta * 500.0, 1.0)
