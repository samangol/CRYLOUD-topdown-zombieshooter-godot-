extends Node2D

func _ready() -> void:
	randomize()
	if randi() % 2 == 0:
		$TextureRect.texture = load('res://Assets/GUN_SMG.png')
	else:
		$TextureRect.texture = load('res://Assets/sword.png')
		
