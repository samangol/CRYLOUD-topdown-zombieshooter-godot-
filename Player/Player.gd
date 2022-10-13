extends KinematicBody2D
class_name Player

onready var flash_timer: Timer = $FlashTimer
onready var hurtbox: Area2D = $Hurtbox
onready var GUI = get_node('../GUI')
onready var gunSprite: Sprite = get_node('Body/SMG/Sprite')
onready var body: Node2D = $Body
onready var pistol_sfx: AudioStreamPlayer = $PistolSFX
#onready var ray_cast_2d = $Body/RayCast2D
onready var flashLight = $Body/FlashLight
onready var lantern: Light2D = $Lantern
onready var lantern_2: Light2D = $Lantern2
onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
onready var ray_container: Node2D = $Body/SMG/RayContainer
onready var muzzleFlash = preload('res://Player/MuzzleFlash.tscn')
var blood_effect = load('res://Enemies/Blood_effect.tscn')

export var maxSpeed = 100
export var friction = 20
export var acceleration = 20
export var recoil = 50
export var gun_knockback = 5
export var gun_damage = 25
var health = 100
var healthMax = 100

var velocity = Vector2.ZERO
var extra_vel = Vector2.ZERO
var gunShotSounds = []
var gunsfx
var flashTimer_max = 100.0
var flashTimer = 100.0
var lvl = 7
var xp = 650
var xp_required = 800
var get_hurt
var flash_on = false



func _ready() -> void:
	randomize()
	ray_container.scale = Vector2(rand_range(.5,1), 1)
	
	
	flash_timer
	flashLight.enabled = false
	lantern.enabled = false
	lantern_2.enabled = false
	flash_on = false

	health = healthMax
	
	get_hurt = preload('res://SFX/Enemy_hurt.wav')
	gunShotSounds.append(preload('res://SFX/22 Pistol-1.wav'))
	gunShotSounds.append(preload('res://SFX/22 Pistol-2.wav'))
	gunShotSounds.append(preload('res://SFX/22 Pistol-3.wav'))
	gunsfx = preload('res://SFX/GunSFX.wav')
	pass


func _physics_process(delta: float) -> void:
	
	get_move_input()
	move_state(delta)
	shoot()
	move()
	flash_light_func()

func flash_light_func():
	if Input.is_action_just_pressed('lighton-off'):
		if !flash_on:
			flash_on =  true
			flashLight.enabled = true
			lantern.enabled = true
			lantern_2.enabled = true
		else:
			flash_on = false
			flashLight.enabled = false
			lantern.enabled = false
			lantern_2.enabled = false

func move():
	extra_vel = lerp(extra_vel, Vector2.ZERO, .8)
	velocity = move_and_slide(velocity + extra_vel)
	

func get_move_input():
	var input = Vector2.ZERO
	input.x = Input.get_axis('moveleft','moveright')
	input.y = Input.get_axis('moveup','movedown')
	input = input.normalized()
	body.look_at(get_global_mouse_position())
	if get_global_mouse_position().x - position.x < 0:
		gunSprite.flip_v = true
		gunSprite.offset = Vector2(0,-4)
	else:
		gunSprite.flip_v = false
		gunSprite.offset = Vector2(0,0)
		
		
	return input

func move_state(delta):
	var input = get_move_input()
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func shoot():
	
	if Input.is_action_just_pressed('shoot'):
		
		gun_damage = gun_damage
		
		
		muzzle_flash()
		
		#this should be moved into a system that will change with the gun we change into
		pistol_sfx()
		
		var diff = (global_position - get_global_mouse_position()).normalized() * recoil
		extra_vel = diff
		
		for r in ray_container.get_children():
			ray_container.scale = Vector2(rand_range(.5,1), 1)
			if r.is_colliding():
				var collider = r.get_collider() 
				if r.get_collider().is_in_group('Enemy'):
					var blood_effect_ins = blood_effect.instance()
					get_tree().current_scene.add_child(blood_effect_ins)
					blood_effect_ins.global_position = collider.global_position
					blood_effect_ins.rotation = collider.global_position.angle_to_point(global_position)
			
					var gun_damage_buffer = gun_damage * min(gun_damage, randi() % 6 + 1)
					collider.health -= gun_damage
					collider.take_damage(gun_knockback, gun_damage,gun_damage_buffer,collider)
		
func muzzle_flash():
	var muzzleFlash_ins = muzzleFlash.instance()
	get_tree().current_scene.add_child(muzzleFlash_ins)
	muzzleFlash_ins.global_position = ray_container.global_position
	muzzleFlash_ins.rotation_degrees = body.rotation_degrees
	muzzleFlash_ins.emitting = false
	muzzleFlash_ins.one_shot = true
	muzzleFlash_ins.local_coords = false
	muzzleFlash_ins.emitting = true
	
func pistol_sfx():
	pistol_sfx.stream = gunsfx
	pistol_sfx.pitch_scale = rand_range(.75,1.5)
	pistol_sfx.play()
	
#func take_damage(attackerPos,knockback, damage):
#
#	audio_stream_player.stream = get_hurt
#	audio_stream_player.pitch_scale = rand_range(1.75,1.95)
#	audio_stream_player.play()
#
#	var dir = (global_position - attackerPos).normalized() * knockback
#	position += dir
#
#	health -= damage
#	print(health)
#	GUI.update_hp_bar(health)
#
##	var text = floatingText.instance()
##	text.amount = damage
##	text.type = 'damage'
##	add_child(text)
	
	if health <= 0:
		onDeath()
	pass
	
func onDeath():
	queue_free()
	pass
	
#func onHit(damage):
#	health -= damage
#	print(health)
#	var health_changed = true
#	health_changed != health_changed
#	if health_changed or !health_changed:
#		GUI.update_hp_bar(health)

func onKill(xp_gained):
	var lvled = false
	xp += xp_gained
	while xp >= xp_required:
		lvlUp()
		xp -= xp_required
		lvled = true
	GUI.update_xp_bar(lvled)
		
func lvlUp():
	lvl += 1
	pass

func sounds_random(s:Array):
	s.shuffle()
	pistol_sfx.stream = gunShotSounds.front()

func fire_shotgun():
	if Input.is_action_just_pressed('shoot'):
		for r in ray_container.get_children():
			ray_container.scale = Vector2(rand_range(.5,1), 1)
			if r.is_colliding():
				if r.get_collider().is_in_group('Enemy'):
					var gun_damage_buffer = gun_damage * min(gun_damage, randi() % 6 + 1)
					r.get_collider().health -= gun_damage
					r.get_collider().take_damage(gun_knockback, gun_damage,gun_damage_buffer,r.get_collider())




func _on_Hurtbox_area_entered(area: Area2D) -> void:
	
	hurtbox.start_invincibility(1)
	
	audio_stream_player.stream = get_hurt
	audio_stream_player.pitch_scale = rand_range(1.75,1.95)
	audio_stream_player.play()
	
	var dir = (global_position - area.global_position).normalized() * area.knockback
	position += dir
	
	health -= area.damage
	print(health)
	GUI.update_hp_bar(health)


func _on_FlashTimer_timeout() -> void:
	if flash_on:
		flashTimer -= 1
		print(flashTimer)
		GUI.update_flash_ui()

	elif !flash_on:
		print(flashTimer)
		if flashTimer == 100:
			return
		flashTimer += 1
		GUI.update_flash_ui()
		
