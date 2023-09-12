class_name SpawnIndicator
extends Sprite2D


signal timer_finished(indicator: SpawnIndicator)

@onready var timer := $Timer


func _physics_process(_delta: float) -> void:
	modulate.a = 255 * int(sin(timer.time_left * 16) >= 0)


func _on_timer_timeout() -> void:
	timer_finished.emit(self)
