extends Position2D

onready var label: Label = $Label
onready var tween: Tween = $Tween

var amount = 0
var type = ''
var vel = Vector2.ZERO


func _ready() -> void:
	label.set_text(str(amount))
	match type:
		'heal':
			label.set('custom_colors/font_color',Color.green)
		'damage':
			label.set('custom_colors/font_color',Color.red)
	randomize()
	var side_move = randi() % 80 - 40
	vel = Vector2(side_move, 25)
	tween.interpolate_property(self, 'scale', scale,Vector2(1,1), .2, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1,1), Vector2(.1,.1), .7, Tween.TRANS_LINEAR,Tween.EASE_OUT, .3)
	tween.start()
func _process(delta: float) -> void:
	position -= vel * delta

func _on_Tween_tween_all_completed() -> void:
	self.queue_free()
