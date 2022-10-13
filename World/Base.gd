extends Node2D

onready var chest: Area2D = $Chest
onready var player = get_node('../Player')
onready var light_2d: Light2D = $Light2D
onready var tween: Tween = $Tween
onready var sprite: Sprite = $Sprite
onready var tweenTimer = $Timer

var chest_can_open = false
var chest_is_open = false

func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	tweenTimer.start(rand_range(1,5))
	
func open_chest():
	chest_is_open = true
	print(chest_is_open)
	pass

func _process(delta: float) -> void:
	pass
	
func lightGlitch():
	tween.interpolate_property(light_2d, 'energy', .7, 1,.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.interpolate_property(light_2d, 'energy', 1, .1, .2, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.interpolate_property(light_2d, 'energy', .1, 1, .2, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()



func _on_Chest_body_entered(body: Node) -> void:
	if body is Player:
		chest_can_open = true



func _on_Chest_body_exited(body: Node) -> void:
	if body is Player:
		chest_can_open = false
		if chest_is_open:
			chest_is_open = false


func _on_Timer_timeout() -> void:
	lightGlitch()
	tweenTimer.start(rand_range(.5,5))



	
