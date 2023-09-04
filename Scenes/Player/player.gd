extends CharacterBody2D


@export var SPEED := 64.0
@export var max_hp := 10

@onready var animation_player := $AnimationPlayer
@onready var marker := $Marker2D
@onready var sprite := $Sprite
@onready var arrow_pos := $Marker2D/ArrowPosition
@onready var bow_timer := $Marker2D/BowCooldown
@onready var progress_bar := $CooldownBar

var direction := Vector2.ZERO
var smoothed_mouse_pos := Vector2.ZERO
var arrow_scene := preload("res://Scenes/Attacks/arrow.tscn")

var hp := max_hp


func _ready() -> void:
	Hud.set_max_health(max_hp)
	Hud.set_health(hp)


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
		var arrow := arrow_scene.instantiate() as Arrow
		arrow.global_position = arrow_pos.global_position
		arrow.rotation_degrees = marker.rotation_degrees
		arrow.direction = (get_global_mouse_position() - global_position).normalized()
		get_tree().get_root().add_child(arrow)
		bow_timer.start()


func _update_cooldown_bar() -> void:
	progress_bar.value = 1.0 - (bow_timer.time_left / 1.25)
	if progress_bar.value == 1.0:
		progress_bar.modulate = Color(0.5, 1.0, 0.5, 1.0)
	else:
		progress_bar.modulate = Color(1.0, 1.0, 1.0, 1.0)


func hurt(damage: int) -> void:
	hp -= damage
	Hud.set_health(hp)


func DEBUG() -> void:
	if Input.is_action_just_pressed("DEBUG_hurt"):
		hurt(1)
	if Input.is_action_just_pressed("DEBUG_heal"):
		hurt(-1)
