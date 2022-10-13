extends Node2D

onready var light_2d: Light2D = $Light2D

export var lightEnergy = 1
export var lightColor = Color.red

func _ready() -> void:
	light_2d.energy = lightEnergy
	
