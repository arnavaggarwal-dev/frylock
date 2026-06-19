extends Node3D

@onready var fry = $Fry
var soggy_factor := 0.0
var sogginess_rate := 0.0
var http_request: HTTPRequest

func _ready():
	print("sogginess script started")
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_weather_received)
	fetch_weather()

func fetch_weather():
	http_request.request("https://wttr.in/?format=j1")

func _on_weather_received(_result, response_code, _headers, body):
	if response_code != 200:
		sogginess_rate = 0.0002
		return
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var data = json.get_data()
	
	var humidity = float(data["current_condition"][0]["humidity"])
	var temp_c = float(data["current_condition"][0]["temp_C"])
	
	sogginess_rate = (humidity / 100.0) * 0.00015 + (max(temp_c, 0.0) / 40.0) * 0.00005
	
	print("Humidity: ", humidity, " Temp: ", temp_c, " → Sogginess rate: ", sogginess_rate)

func _process(delta):
	if soggy_factor >= 1.0:
		return
	
	soggy_factor = min(soggy_factor + sogginess_rate * delta * 500.0, 1.0)
	
	var mat = fry.get_active_material(0)
	if mat:
		mat.set_shader_parameter("soggy_factor", soggy_factor)
	else:
		print("still no material")
