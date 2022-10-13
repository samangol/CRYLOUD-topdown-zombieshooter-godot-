extends CanvasLayer

onready var player = get_node('../Player')
onready var lvlLabel = get_node('XPBar/HBoxContainer/TextureRect/Label')
onready var xpBar = get_node('XPBar/HBoxContainer/TextureProgress')
onready var xpBarLabel = get_node('XPBar/HBoxContainer/TextureProgress/Label')
onready var hpBar = get_node('Hp/HBoxContainer/TextureProgress2')
onready var hpBarLabel = get_node('Hp/HBoxContainer/TextureProgress2/Label')
onready var flashBar = get_node('FlashBar/HBoxContainer/TextureProgress')
onready var flashBarLabel = get_node('FlashBar/HBoxContainer/TextureProgress/Label')

var xpBarState = 'value'

func _ready() -> void:
	set_xp_bar()
	set_hp_bar()
	set_flash_bar()

func set_xp_bar():
	lvlLabel.set_text(str(player.lvl))
	xpBar.max_value = player.xp_required
	xpBar.value = player.xp
	xpBarLabel.text = str(str(player.xp) + ' / ' + str(player.xp_required))
	pass
	
func set_hp_bar():
	hpBarLabel.set_text(str(player.health))
	hpBar.max_value = player.healthMax
	hpBar.value = player.health
	hpBarLabel.text = str(str(player.health) + ' / ' + str(player.healthMax))
	pass

func set_flash_bar():
	flashBarLabel.set_text(str(player.flashTimer))
	flashBar.max_value = player.flashTimer_max
	flashBar.value = player.flashTimer

func update_xp_bar(lvled):
	if lvled == true:
		xpBar.max_value = player.xp_required
		lvlLabel.text = str(player.lvl)
	else:
		pass
	xpBar.value = player.xp
	xpBarLabel.text = str(str(player.xp) + ' / ' + str(player.xp_required))

func update_hp_bar(value):
	hpBar.value = player.health
	hpBarLabel.text = str(str(player.health) + ' / ' + str(player.healthMax))
	pass

func update_flash_ui():
	flashBar.value = player.flashTimer
	flashBarLabel.set_text(str((player.flashTimer/player.flashTimer_max)*100, ' %'))
	
