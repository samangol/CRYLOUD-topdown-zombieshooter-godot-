extends Position2D

onready var timer: Timer = $Timer
onready var enemy = preload('res://Enemies/Enemy.tscn')

var randPos = Vector2(rand_range(-16,16),rand_range(-16,16))

func _ready() -> void:
	
	timer.start(5)
	
func spawnEnemy():
	var enemy_ins = enemy.instance()
	enemy_ins.global_position = randPos
	get_tree().current_scene.add_child(enemy_ins)
	
	


func _on_Timer_timeout() -> void:
	timer.start(5)
	spawnEnemy()
