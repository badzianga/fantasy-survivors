extends CharacterBody2D


const SPEED = 64.0

@onready var animation_player := $AnimationPlayer
@onready var marker := $Marker2D
@onready var sprite := $Sprite
@onready var arrow_pos := $Marker2D/ArrowPosition

var direction := Vector2.ZERO
var smoothed_mouse_pos := Vector2.ZERO
var arrow_scene := preload("res://Scenes/Attacks/arrow.tscn")

func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_animation()
	_rotate_weapon()
	_handle_arrow_shooting()


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
	if Input.is_action_just_pressed("shoot"):
		var arrow := arrow_scene.instantiate() as Area2D
		arrow.global_position = arrow_pos.global_position
		arrow.rotation_degrees = marker.rotation_degrees
		arrow.direction = (get_global_mouse_position() - global_position).normalized()
		get_tree().get_root().add_child(arrow)
