extends KinematicBody2D
class_name Enemy
 
onready var attack_timer: Timer = $AttackTimer
onready var area_2d: Area2D = $Area2D
onready var wander_controller: Node2D = $WanderController
onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
onready var attack_kite: Timer = $AttackKite
onready var invincibility_timer: Timer = $InvincibilityTimer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
var floatingText = preload('res://Player/FloatingText.tscn')

var blood_effect = load('res://Enemies/Blood_effect.tscn')
onready var GUI = get_node('../GUI')

var velocity = Vector2.ZERO
var extra_vel = Vector2.ZERO
var path:Array = []
var player = null
var levelNav = null
var get_hurt
var canTakeDamage = true

export var xp_pool = 100
export var kiteTimer = 4
export var speed = 50
export var friction = 40
export var health = 1000
export var damage = 25
export var knockback = 5

enum {
	IDLE,
	WANDER,
	ATTACK
}
var state

func _ready() -> void:
	
	get_hurt = preload('res://SFX/Enemy_hurt.wav')
	
	yield(get_tree(), 'idle_frame')
	
	animated_sprite.play('Idle')
	
	state = IDLE
	
	var tree = get_tree()
	if tree.has_group('levelNav'):
		levelNav = tree.get_nodes_in_group('levelNav')[0]
	if tree.has_group('player'):
		player = tree.get_nodes_in_group('player')[0]


func _physics_process(delta: float) -> void:
	

	match state:
		IDLE:
			animated_sprite.play('Idle')
			idle_state(delta)
				
		WANDER:
			animated_sprite.play('Run')
			
			wander_state(delta)

		ATTACK:
			animated_sprite.play('Run')
			
			attack_state(delta)
			
	velocity = move_and_slide(velocity + extra_vel)
	

func navigate(delta):
	if path.size()>0:
		velocity = global_position.direction_to(path[1]) * speed
#		look_at(player.global_position)
			
		if global_position == path[0]:
			path.pop_front()
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			
			
func generate_path():
	if levelNav != null and player != null:
		path = levelNav.get_simple_path(global_position, player.global_position, false)

func generate_wander_path():
	if levelNav != null and player != null:
		path = levelNav.get_simple_path(global_position, wander_controller.target_position, false)
	if global_position == wander_controller.target_position:
		state = pick_random_state([IDLE, WANDER])
		wander_controller.start_wander_timer(.1)
func attack_state(delta):
	if velocity.x < 0:
			$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
	generate_path()
	navigate(delta)

	
func wander_state(delta):
	if velocity.x < 0:
			$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		pass
#	var dir = Vector2.ZERO
	if wander_controller.get_wander_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wander_controller.start_wander_timer(rand_range(1,3))
#	dir = global_position.direction_to(wander_controller.target_position)
#	rotation = (wander_controller.target_position - position).angle()
	generate_wander_path()
	navigate(delta)
	
		
		
#			velocity = velocity.move_toward(dir * speed, acceleration * delta)

func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if wander_controller.get_wander_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wander_controller.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func take_damage(knockback, gun_damage,gun_damage_buffer, collider):
	
	state = ATTACK
	attack_kite.start(kiteTimer)
	
	animated_sprite.play('Hurt')
	
	audio_stream_player.stream = get_hurt
	audio_stream_player.pitch_scale = rand_range(.75,.95)
	audio_stream_player.play()
	
	var dir = (global_position - player.global_position).normalized() * knockback
	position += dir
	
	var damage = gun_damage + gun_damage_buffer
	health -= damage 
	var text = floatingText.instance()
	text.amount = damage
	text.type = 'damage'
	add_child(text)
	
	if health <= 0:
		onDeath()
	pass

func onDeath():
	player.onKill(xp_pool)
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		state = ATTACK

func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		state = pick_random_state([IDLE, WANDER])
		wander_controller.start_wander_timer(rand_range(1,3))

func _on_AttackKite_timeout() -> void:
	if !canTakeDamage:
		state = pick_random_state([IDLE, WANDER])
	
	
#func _on_Hitbox_body_entered(body: Node) -> void:
#	if body == player and attack_timer.time_left <= 0:
#		body.take_damage(global_position, knockback, damage)
##		attack_timer.start(1)
#		print('player damaged')
#
#
#func _on_AttackTimer_timeout() -> void:
#	player.take_damage(global_position,knockback, damage)
#	canTakeDamage = true
#
#
#func _on_Hitbox_body_exited(body: Node) -> void:
#	if body == player:
#		attack_timer.stop()
#
#
#
#func _on_InvincibilityTimer_timeout() -> void:
#	pass # Replace with function body.


	
