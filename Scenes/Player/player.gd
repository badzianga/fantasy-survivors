extends CharacterBody2D


const ArrowScene = preload("res://Scenes/Attacks/arrow.tscn")

@export var SPEED := 64.0

@onready var animation_player := $AnimationPlayer
@onready var marker := $Marker2D
@onready var sprite := $Sprite
@onready var arrow_pos := $Marker2D/ArrowPosition
@onready var bow_timer := $Marker2D/BowCooldown
@onready var progress_bar := $CooldownBar
@onready var shoot_sound := $Marker2D/ShootSound
@onready var walk_sound := $WalkSound
@onready var health := $HealthComponent as HealthComponent
@onready var effects := $Effects
@onready var exp_component := $ExpComponent as ExpComponent


var direction := Vector2.ZERO
var smoothed_mouse_pos := Vector2.ZERO


func _ready() -> void:
	Hud.set_max_health(health.max_health)
	Hud.set_health(health.health)
	Hud.set_level(exp_component.level)
	Hud.set_max_exp(exp_component.experience_to_next_level)
	health.health_changed.connect(_on_health_changed)
	exp_component.exp_updated.connect(_on_exp_updated)
	exp_component.exp_updated.connect(_on_levelled_up)

	GameData.player = self


func _physics_process(_delta: float) -> void:	
	_handle_movement()
	_handle_animation()
	_rotate_weapon()
	_handle_arrow_shooting()
	_update_cooldown_bar()
	
	DEBUG()


func _handle_movement() -> void:
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

	velocity = direction.normalized() * SPEED

	if velocity != Vector2.ZERO and not walk_sound.playing:
		walk_sound.pitch_scale = randf_range(0.8, 1.2)
		walk_sound.play()

	move_and_slide()


func _rotate_weapon() -> void:
	smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
	marker.look_at(smoothed_mouse_pos)


func _handle_animation() -> void:
	if direction:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

	sprite.flip_h = (get_global_mouse_position().x - global_position.x) < 0


func _handle_arrow_shooting() -> void:
	if Input.is_action_pressed("shoot") and bow_timer.is_stopped():
		var arrow := ArrowScene.instantiate() as Arrow
		arrow.global_position = arrow_pos.global_position
		arrow.rotation_degrees = marker.rotation_degrees
		arrow.direction = (get_global_mouse_position() - arrow_pos.global_position).normalized()
		get_tree().get_root().add_child(arrow)
		bow_timer.start()
		
		shoot_sound.pitch_scale = randf_range(0.8, 1.2)
		shoot_sound.play()


func _update_cooldown_bar() -> void:
	progress_bar.value = 1.0 - (bow_timer.time_left / bow_timer.wait_time)
	if progress_bar.value == 1.0:
		progress_bar.modulate = Color(0.5, 1.0, 0.5, 1.0)
	else:
		progress_bar.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_health_changed() -> void:
	effects.play("hurt")
	Hud.set_health(health.health)


func _on_exp_updated() -> void:
	Hud.set_exp(exp_component.experience)


func _on_levelled_up() -> void:
	Hud.set_max_exp(exp_component.experience_to_next_level)
	Hud.set_level(exp_component.level)


func DEBUG() -> void:
	if Input.is_action_just_pressed("DEBUG_hurt"):
		health.apply_damage(1)
	if Input.is_action_just_pressed("DEBUG_heal"):
		health.apply_damage(-1)
	if Input.is_action_just_pressed("DEBUG_add_exp"):
		exp_component._add_experience(1)
