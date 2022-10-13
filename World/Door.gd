extends Position2D

onready var timer: Timer = $Timer
onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var door_can_open = false
var body_entered = false
var door_is_open = false

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		door_can_open = true
		body_entered = true

		
		
func _process(delta: float) -> void:
	if body_entered:
		if door_can_open and !door_is_open and Input.is_action_just_pressed('interact'):
			timer.start(5)
			animation_player.play('Open')
			door_is_open = true
		elif door_can_open and door_is_open and Input.is_action_just_pressed('interact'):
			timer.stop()
			animation_player.play('Close')
			door_is_open = false


func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		door_can_open = false
		body_entered = false


func _on_Timer_timeout() -> void:
	door_is_open = false
	animation_player.play('Close')
