class_name Arrow
extends Area2D


@export var speed := 80.0
var direction := Vector2.RIGHT


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_timer_timeout() -> void:
	queue_free()
