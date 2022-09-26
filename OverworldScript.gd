extends Node2D

var paused = false

#Mouse Input
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		print("Click!")
		#We need a way for the click to detect the players and npcs

#Weather
var weather_rng = RandomNumberGenerator.new()
var weather = 0

func set_weather(value):
	weather = value

func set_starting_weather():
	weather_rng.randomize()
	var weather_calc = weather_rng.randi_range(0,99)
	if weather_calc <= 54:
		set_weather(0)
	elif weather_calc > 54 and weather_calc <= 74:
		set_weather(1)
	elif weather_calc > 74 and weather_calc <= 89:
		set_weather(2)
	elif weather_calc > 89 and weather_calc <= 98:
		set_weather(4)
	else:
		set_weather(5)

func _ready():
	set_starting_weather()
	match weather:
		0:
			print("It's cloudy today.")
		1:
			print("Not a cloud in the sky.")
		2:
			print("Looks like rain.")
		3:
			print("A sandstorm is coming this way.")
		4:
			print("It's windy out.")
		5:
			print("An eclipse! It's a once in a lifetime experience.")
