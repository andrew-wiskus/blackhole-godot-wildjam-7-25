@tool
extends Node3D
class_name BlackHoleCharacterAnimator

@onready var eye_left__eyeball: Sprite3D = $AnimatedSprite3D/EYE_LEFT__EYEBALL
@onready var eye_left__iris: Sprite3D = $AnimatedSprite3D/EYE_LEFT__EYEBALL/EYE_LEFT__IRIS

@onready var eye_right__eyeball: Sprite3D = $AnimatedSprite3D/EYE_RIGHT__EYEBALL
@onready var eye_right__iris: Sprite3D = $AnimatedSprite3D/EYE_RIGHT__EYEBALL/EYE_RIGHT__IRIS

var eye_right__max_left = -0.05
var eye_right__max_right = 1.55

var eye_left__max_left = -1.55
var eye_left__max_right = 0.05

var eye_max_up = 0.4
var eye_max_down = -0.4

var iris_max_distance = 0.7
var iris_max_scale = 1.5 # on max scale if in center.. 
var iris_min_scale = 0.5 
var iris_default_scale = 1.0

var default_z = 0.5
var default_eyeball_scale = Vector3.ONE * 0.55

var center_position = Vector3(0,0,default_z)
var center_left_eye_position = Vector3(-0.85, 0, default_z)
var center_right_eye_position = Vector3(0.85, 0, default_z)

@export_tool_button("Centered")   var _btn_centered   = set_eyes__centered
@export_tool_button("Surprised")   var _btn_surprised   = set_eyes__surprised
@export_tool_button("Look Right")  var _btn_face_right  = set_eyes__face_right
@export_tool_button("Look Left")   var _btn_face_left   = set_eyes__face_left
@export_tool_button("Cross Eyed")  var _btn_cross_eyed  = set_eyes__cross_eyed

func set_eyes__centered():
	eye_left__eyeball.position = center_left_eye_position
	eye_right__eyeball.position = center_right_eye_position
	eye_left__iris.position  = center_position
	eye_right__iris.position = center_position
	
	eye_left__iris.scale  = Vector3.ONE
	eye_right__iris.scale = Vector3.ONE
	eye_left__eyeball.scale  = default_eyeball_scale * 0.9
	eye_right__eyeball.scale = default_eyeball_scale * 0.9

func _reset():
	set_eyes__centered()

func set_eyes__surprised():
	_reset()
	# Center both irises and enlarge
	eye_left__eyeball.position = Vector3(1.15, 0.2, default_z)
	eye_right__eyeball.position = Vector3(-1.15, 0.2, default_z)
	
	eye_left__eyeball.scale = default_eyeball_scale * 1.2
	eye_right__eyeball.scale = default_eyeball_scale * 1.2
	eye_left__iris.scale     = Vector3.ONE * iris_max_scale
	eye_right__iris.scale    = Vector3.ONE * iris_max_scale

func set_eyes__face_right():
	_reset()
	
	eye_left__eyeball.position  = Vector3(eye_left__max_right, 0, default_z + 0.1) # overlap over eye
	eye_right__eyeball.position = Vector3(eye_right__max_right, 0, default_z)
	eye_left__iris.position     = Vector3(0.2, 0, default_z)
	eye_right__iris.position     = Vector3(0.2, 0, default_z)

func set_eyes__face_left():
	_reset()
	
	eye_left__eyeball.position  = Vector3(eye_left__max_left, 0, default_z)
	eye_right__eyeball.position = Vector3(eye_right__max_left, 0, default_z + 0.1) # overlap other eye
	eye_left__iris.position     = Vector3(-0.2, 0, default_z)
	eye_right__iris.position     = Vector3(-0.2, 0, default_z)


func set_eyes__cross_eyed():
	_reset()
	
	eye_left__iris.position  = Vector3(0.45, -0.3, default_z)
	eye_right__iris.position = Vector3(-0.45, -0.3,  default_z)
	eye_left__iris.scale     = Vector3.ONE * iris_min_scale
	eye_right__iris.scale    = Vector3.ONE * iris_min_scale
