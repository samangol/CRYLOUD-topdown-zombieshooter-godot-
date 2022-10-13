extends RigidBody2D

var floatingText = preload('res://Player/FloatingText.tscn')
var player = Player

func take_damage(knockback, gun_damage,gun_damage_buffer, collider):
	var damage = gun_damage + gun_damage_buffer
	var text = floatingText.instance()
	text.amount = damage
	text.type = 'damage'
	add_child(text)

func _ready() -> void:
	randomize()
	var random = Vector2(rand_range(-10,10), rand_range(-10,10))
	add_force(Vector2.ZERO, Vector2(random.x, random.y))
	


func _on_Timer_timeout() -> void:
	var random = Vector2(rand_range(-10,10), rand_range(-10,10))
	add_force(Vector2.ZERO, Vector2(random.x, random.y))


func _on_Area2D_area_entered(area: Area2D) -> void:
	var random = Vector2(rand_range(-10,10), rand_range(-10,10))
	add_force(Vector2.ZERO, Vector2(random.x, random.y))
