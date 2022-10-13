extends Node2D

onready var player: KinematicBody2D = $Player
var debug_overlay = preload('res://debug_overlay.tscn')
onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	randomize()
	player.get_node('RemoteTransform2D').remote_path = camera_2d.get_path()
	
	debug_overlay = debug_overlay.instance()
	add_child(debug_overlay)
	debug_overlay.add_stats('Gun Collider', $Player/Body/RayCast2D, 'get_collider', true)
