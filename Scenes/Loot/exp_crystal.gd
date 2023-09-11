class_name ExpCrystal
extends Area2D


var amount := 0
var speed := -0.75


func _ready() -> void:
	set_physics_process(false)
	$CollectSound.pitch_scale = randf_range(0.8, 1.2)


func _physics_process(delta: float) -> void:
	speed += 2.0 * delta
	global_position = global_position.move_toward(GameData.player.global_position, speed)


func set_amount(exp_amount: int) -> void:
	amount = exp_amount


func grab() -> void:
	set_physics_process(true)


func collect() -> int:
	$CollectSound.play()
	$CollisionShape.set_deferred("disabled", true)
	$Sprite.visible = false
	return amount


func _on_collect_sound_finished() -> void:
	queue_free()
