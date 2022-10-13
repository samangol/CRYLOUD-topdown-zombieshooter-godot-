extends Node2D

onready var light_2d: Light2D = $Light2D


var player_in = false
func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
#		print('player entered')
		player_in = true

func _on_Area2D_body_exited(body: Node) -> void:
	player_in = false
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed('interact') and player_in:
			if light_2d.enabled:
				light_2d.enabled = false
#				print('lamp off')
			else:
				light_2d.enabled = true
