extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder

@export var move_speed = 150.0
@export var accel_frames = 3

var _last_input = Vector2()

var facing = Consts.Facing.RIGHT

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()

func _process(_delta):
	var input = Vector2()
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")

	if input.x or velocity.x:
		facing = Consts.Facing.RIGHT if velocity.x > 0 else Consts.Facing.LEFT
		animated_sprite.flip_h = false if velocity.x > 0 else true
		animated_sprite.play("walk side")

	elif input.y or velocity.y:
		facing = Consts.Facing.DOWN if velocity.y > 0 else Consts.Facing.UP
		var animation = "walk down" if velocity.y > 0 else "walk up"
		animated_sprite.play(animation)

	elif _last_input.x:
		facing = Consts.Facing.RIGHT if _last_input.x > 0 else Consts.Facing.LEFT
		animated_sprite.flip_h = false if _last_input.x > 0 else true
		animated_sprite.play("idle side")

	elif _last_input.y:
		facing = Consts.Facing.DOWN if _last_input.y > 0 else Consts.Facing.UP
		var animation = "idle down" if _last_input.y > 0 else "idle up"
		animated_sprite.play(animation)

func _physics_process(delta):
	# Replace UI actions with custom gameplay actions.
	var input = Vector2()
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")

	if input.x or input.y:
		_last_input.x = input.x
		_last_input.y = input.y

	if input.x:
		velocity.x = move_toward(velocity.x, input.x * move_speed, move_speed / accel_frames)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed / accel_frames)

	if input.y:
		velocity.y = move_toward(velocity.y, input.y * move_speed, move_speed / accel_frames)
	else:
		velocity.y = move_toward(velocity.y, 0, move_speed / accel_frames)

	move_and_slide()
