extends TileMap

onready var level =$'../TileMap'
onready var obstacles =$'../TileObs'

func _ready():
	var level_cells = level.get_used_cells_by_id(0) #if tile id 0 
	var obstacles_cells = obstacles.get_used_cells()
	for i in obstacles_cells:
		level_cells.erase(i)
	for i in level_cells:
		set_cellv(i,0)
