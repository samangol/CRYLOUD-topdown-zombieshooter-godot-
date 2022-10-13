extends Area2D

var invincible = false setget set_invincible
onready var timer = $Timer

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal('invincibility_started')
		print(' start signal emited')
	else:
		emit_signal('invincibility_ended')
		print(' end signal emited')
		

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	print('timer strarted')
	


func _on_Hurtbox_invincibility_started() -> void:
	print('not monitorable')
	set_deferred('monitoring',false)
	#monitorable = false


func _on_Hurtbox_invincibility_ended() -> void:
	print('monitorable')
	monitoring = true


func _on_Timer_timeout() -> void:
	print('timeout')
	self.invincible = false
