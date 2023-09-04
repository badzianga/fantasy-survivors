extends CanvasLayer


@onready var health_bar := $Control/HealthBar

func set_health(hp: int) -> void:
	health_bar.value = hp


func set_max_health(max_hp: int) -> void:
	health_bar.max_value = max_hp
