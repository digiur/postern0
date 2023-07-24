extends WorldEnvironment

var packedSound2d = preload("res://scenes/Sound/demo2d_bgm.tscn")
var packedSound3d = preload("res://scenes/Sound/demo3d_bgm.tscn")
var sound2d = packedSound2d.instantiate()
var sound3d = packedSound3d.instantiate()

var packedWorld2d = preload("res://scenes/worlds/2d/demo2d.tscn")
var packedWorld3d = preload("res://scenes/worlds/3d/demo3d.tscn")
var world2d = packedWorld2d.instantiate()
var world3d = packedWorld3d.instantiate()

var packedPlayer2d = preload("res://scenes/player/player2d.tscn")
var packedPlayer3d = preload("res://scenes/player/player3d.tscn")
var player2d = packedPlayer2d.instantiate()
var player3d = packedPlayer3d.instantiate()

var worldState = Consts.WorldState.TWOD

const metersPerPixel = 0.0625
const pixelsPerMeter = 16.0

func _ready():
	add_child(world2d)
	add_child(player2d)
	add_child(sound2d)
	add_child(sound3d)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("2D"), false)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("3D"), true)

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if worldState == Consts.WorldState.TWOD:
			switchTo3D()
		elif worldState == Consts.WorldState.THREED: 
			switchTo2D()

func switchTo3D():
	remove_child(player2d)
	remove_child(world2d)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("2D"), true)

	player3d.position.x = player2d.position.x * metersPerPixel
	player3d.position.y = 1.0
	player3d.position.z = player2d.position.y * metersPerPixel

	if player2d.facing == Consts.Facing.UP:
		player3d.transform = player3d.transform.looking_at(player3d.position + Vector3.FORWARD)

	elif player2d.facing == Consts.Facing.LEFT:
		player3d.transform = player3d.transform.looking_at(player3d.position + Vector3.LEFT)

	elif player2d.facing == Consts.Facing.RIGHT:
		player3d.transform = player3d.transform.looking_at(player3d.position + Vector3.RIGHT)

	elif player2d.facing == Consts.Facing.DOWN:
		player3d.transform = player3d.transform.looking_at(player3d.position + Vector3.BACK)

	add_child(world3d)
	add_child(player3d)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("3D"), false)

	worldState = Consts.WorldState.THREED

func switchTo2D():
	remove_child(player3d)
	remove_child(world3d)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("3D"), true)

	player2d.position.x = player3d.position.x * pixelsPerMeter
	player2d.position.y = player3d.position.z * pixelsPerMeter

	add_child(world2d)
	add_child(player2d)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("2D"), false)

	worldState = Consts.WorldState.TWOD
