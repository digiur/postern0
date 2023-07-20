extends WorldEnvironment

var packedWorld2d = preload("res://scenes/worlds/2d/demo2d.tscn")
var packedWorld3d = preload("res://scenes/worlds/3d/demo3d.tscn")
var packedPlayer2d = preload("res://scenes/player/player2d.tscn")
var packedPlayer3d = preload("res://scenes/player/player3d.tscn")

var world2d
var world3d
var player2d
var player3d

enum {TWOD, THREED}
var worldState = TWOD

const metersPerPixel = 0.0625
const pixelsPerMeter = 16.0

func _ready():
	print('begin ready')
	world2d = packedWorld2d.instantiate()
	world3d = packedWorld3d.instantiate()
	player2d = packedPlayer2d.instantiate()
	player3d = packedPlayer3d.instantiate()

	add_child(world2d)
	add_child(player2d)
	print('ready')

func _input(event):
	if event.is_action_pressed("ui_focus_next"): switch()

func switch():
	if worldState == TWOD:
		remove_child(player2d)
		remove_child(world2d)

		player3d.position.x = player2d.position.x * metersPerPixel
		player3d.position.y = 1.0
		player3d.position.z = player2d.position.y * metersPerPixel

		add_child(world3d)
		add_child(player3d)
		worldState = THREED

	elif worldState == THREED: 
		remove_child(player3d)
		remove_child(world3d)

		player2d.position.x = player3d.position.x * pixelsPerMeter
		player2d.position.y = player3d.position.z * pixelsPerMeter

		add_child(world2d)
		add_child(player2d)
		worldState = TWOD
