extends Node2D

@export var spawn_radius := 96
const SpawnIndicatorScene = preload("res://Scenes/Misc/spawn_indicator.tscn")
const SlimeScene = preload("res://Scenes/Enemies/slime.tscn")


func _on_timer_timeout() -> void:
	_prepare_spawn()


func _prepare_spawn() -> void:
	var indicator := SpawnIndicatorScene.instantiate() as SpawnIndicator
	indicator.global_position = _get_random_position()
	indicator.rotation_degrees = randf_range(0.0, 90.0)
	indicator.timer_finished.connect(_on_spawn_indicator_timer_finished)
	add_child(indicator)


func _spawn_enemy(enemy_position: Vector2) -> void:
	var slime := SlimeScene.instantiate()
	slime.global_position = enemy_position
	add_child(slime)


func _get_random_position() -> Vector2:
	var center := GameData.player.global_position
	var r := spawn_radius * sqrt(randf())
	var theta := TAU * randf()
	return Vector2(center.x + r * cos(theta), center.y + r * sin(theta))


func _on_spawn_indicator_timer_finished(indicator: SpawnIndicator) -> void:
	_spawn_enemy(indicator.global_position)
	indicator.queue_free()
